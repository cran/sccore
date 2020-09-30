#' @importFrom magrittr %>% %<>% %$%
#' @import igraph
#' @importFrom methods as is
#' @importFrom rlang .data 
NULL

## for magrittr and dplyr functions below
if(getRversion() >= "2.15.1"){
  utils::globalVariables(c("."))
}

#' Collapse graph using PAGA 1.2 algorithm, Wolf et al 2019, Genome Biology (2019) <https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1663-x>
#' 
#' @param graph igraph graph object Graph to be collapsed
#' @param groups factor on vertices describing cluster assignment (can specify integer vertex ids, or character vertex names which will be matched)
#' @param linearize should normally be always TRUE (default=TRUE)
#' @param winsorize winsorize final connectivity statistics value (default=FALSE) Note: Original PAGA has it as always TRUE,
#'   but in this case there is no way to distinguish level of connectivity for highly connected groups. 
#' @return collapsed graph 
#' @export
collapseGraphPaga <- function(graph, groups, linearize=TRUE, winsorize=FALSE) {

  if ((!(is(graph, "Matrix") || is(graph, "matrix")) || ncol(graph) != nrow(graph)) && !igraph::is.igraph(graph)) {
    stop("Unknown graph format. Only adjacency matrix or igraph are supported.")
  }

  if (!igraph::is.igraph(graph)) {
    ones <- graph %>% as('dgTMatrix') %>% as('symmetricMatrix')
    ones@x <- rep(1, length(ones@x))
    graph <- igraph::graph_from_adjacency_matrix(ones, mode='directed', weighted=TRUE)
  } else {
    graph %<>% igraph::as.directed()
    igraph::edge.attributes(graph)$weight <- rep(1, igraph::gsize(graph))
  }

  if (!is.null(igraph::V(graph)$name)) {
    groups %<>% .[igraph::V(graph)$name]
    graph %<>% igraph::remove.vertex.attribute("name")
  }

  groups %<>% .[!is.na(.)] %>% as.factor() %>% droplevels()
  if (length(groups) != length(igraph::V(graph))){
    stop("Groups must be provided for all graph vertices.")
  }

  cluster.names <- levels(groups)
  groups %<>% as.integer()

  vc <- igraph::make_clusters(graph, membership = groups, algorithm = 'conos', merges = NULL, modularity = FALSE)
  ns <- igraph::sizes(vc)
  n <- sum(ns)

  es.inner.cluster <- rep(0, length(vc))
  es.inner.cluster[as.integer(names(igraph::groups(vc)))] <- sapply(igraph::groups(vc), function(s)
    igraph::induced_subgraph(graph, s, impl = 'copy_and_delete') %>% igraph::gsize() %>% `*`(2))

  inter.es <- igraph::contract(graph, vc$membership) %>%
    igraph::simplify(remove.multiple=FALSE, remove.loops=TRUE, edge.attr.comb=igraph::igraph_opt("weight")) %>%
    igraph::as_adj(attr="weight") %>% as('dgTMatrix')

  es <- es.inner.cluster + Matrix::rowSums(inter.es)

  inter.es %<>% `+`(Matrix::t(.))
  expected.random.null.vals <- (es[inter.es@i + 1]*ns[inter.es@j + 1] + es[inter.es@j + 1]*ns[inter.es@i + 1])/(n - 1)
  if (!linearize) {
    sd.random.null.vals <- (es[inter.es@i + 1]*ns[inter.es@j + 1]*(n-ns[inter.es@j + 1]-1) +
                              es[inter.es@j + 1]*ns[inter.es@i + 1])*(n-ns[inter.es@i + 1]-1) / ((n - 1)^2)
    scaled.values <- ifelse(sd.random.null.vals < 1e-10, 0, (inter.es@x - expected.random.null.vals)/sd.random.null.vals) %>% as.numeric()
  } else {
    scaled.values <- ifelse(expected.random.null.vals < 1e-10, 1, inter.es@x / expected.random.null.vals) %>% as.numeric()
  }

  if (!is.logical(winsorize) || winsorize) {
    scaled.values %<>% pmin(winsorize)
  }
  inter.es@x <- scaled.values
  dimnames(inter.es) <- list(cluster.names, cluster.names)

  return(inter.es)
}

#' Collapse Graph By Sum
#'
#' @inheritParams collapseGraphPaga
#' @param normalize boolean Whether to recalculate edge weight as observed/expected (default=TRUE)
#' @return collapsed graph
#' @examples 
#' \donttest{
#' collapsed = collapseGraphPaga(conosGraph, igraph::V(conosGraph), linearize=TRUE, winsorize=FALSE)
#' }
#' @export
collapseGraphSum <- function(graph, groups, normalize=TRUE) {

  gcon <- contract.vertices(graph, groups, vertex.attr.comb=list('num'='sum',"ignore")) %>%
    simplify(edge.attr.comb=list(weight="sum","ignore"))

  if(normalize) {
    ex <- outer(V(gcon)$num,V(gcon)$num)/(sum(V(gcon)$num)*(sum(V(gcon)$num)-1)/2)*sum(E(graph)$weight)
    gcon2 <- graph_from_adjacency_matrix(as(as_adjacency_matrix(gcon, attr = "weight", sparse = FALSE)/ex,'dgCMatrix'), mode = "undirected", weighted=TRUE)
    V(gcon2)$num <- V(gcon)$num
    gcon <- gcon2;
  }

  if(is.factor(groups)) {
    V(gcon)$name <- levels(groups)
  } else {
    # not sure when this was actually needed
    gcon <- induced.subgraph(gcon, unique(groups))
  }

  return(gcon)
}

#' Collapse vertices belonging to each cluster in a graph
#'
#' @inheritParams collapseGraphPaga
#' @param method string Method to be used, either "sum" or "paga" (default="sum")
#' @param plot boolean Whether to show collapsed graph plot (default=FALSE)
#' @param node.scale numeric Scaling to control value of 'vertex.size' in plot.igraph() (default=50)
#' @param edge.scale numeric Scaling to control value of 'edge.width' in plot.igraph() (default=50)
#' @param edge.alpha numeric Scaling to control value of 'alpha.f' in adjustcolor() within plot.igraph() (default=0.3) 
#' @param seed numeric Set seed via set.seed() for plotting (default=1)
#' @param ... arguments passed to collapseGraphSum()
#' @return collapsed graph
#' @examples
#' \donttest{
#' cluster.graph = getClusterGraph(conosGraph, igraph::V(conosGraph))
#' }
#' @export
getClusterGraph <- function(graph, groups, method="sum", plot=FALSE, node.scale=50, edge.scale=50, edge.alpha=0.3, seed=1,...) {
  
  V(graph)$num <- 1

  if (is.integer(groups) && is.null(names(groups))) {
    nv <- vcount(graph)
    if (length(groups)!=nv) {
      stop('Length of groups should be equal to the number of vertices')
    }
    if (max(groups)>nv) {
      stop('Groups specifies ids that are larger than the number of vertices in the graph')
    }
    if (any(is.na(groups))) {
      # remove vertices that are not part of the groups
      vi <- which(!is.na(groups))
      g <- induced.subgraph(graph,vi)
      groups <- groups[vi]
    } else {
      g <- graph
    }
  } else {
    gn <- V(graph)$name
    groups <- stats::na.omit(groups[names(groups) %in% gn])
    if (length(groups)<2) {
      stop('Valid names of groups elements include too few cells')
    }
    if (length(groups)<length(gn)) {
      g <- induced.subgraph(graph,names(groups))
    } else {
      g <- graph;
    }
    if(is.factor(groups)) {
      groups <- groups[V(g)$name]
    } else {
      groups <- as.factor(stats::setNames(as.character(groups[V(g)$name]),V(g)$name))
    }
  }

  if (method == "sum") {
    gcon <- collapseGraphSum(g, groups, ...)
  } else if (method == "paga") {
    gcon <- collapseGraphPaga(g, groups, ...)
  } else {
    stop("Unknown method: ", method)
  }

  if (plot) {
    set.seed(seed)
    withr::with_par(mar = rep(0.1, 4), 
      plot.igraph(gcon, layout=layout_with_fr(gcon), vertex.size=V(gcon)$num/(sum(V(gcon)$num)/node.scale), 
        edge.width=E(gcon)$weight/sum(E(gcon)$weight/edge.scale), adjustcolor('black', alpha.f=edge.alpha))
    )
  }

  return(invisible(gcon))
}

#' Estimate labeling distribution for each vertex, based on provided labels.
#'
#' @param graph igraph graph object 
#' @param labels vector of factor or character labels, named by cell names, used in propagateLabelsSolver() and propagateLabelsDiffusion()
#' @param method string Type of propagation. Either 'diffusion' or 'solver'. (default='diffusion') 'solver' gives better result
#'  but has bad asymptotics, so it is inappropriate for datasets > 20k cells. 
#' @param ... additional arguments passed to either propagateLabelsSolver() or propagateLabelsDiffusion()
#' @return matrix with distribution of label probabilities for each vertex by rows.
#' @examples 
#' propagateLabels(conosGraph, labels=cellAnnotations)
#'
#' @export
propagateLabels = function(graph, labels, method="diffusion", ...) {
  if (method == "solver") {
    label.dist <- propagateLabelsSolver(graph, labels, ...)
  } else if (method == "diffusion") {
    label.dist <- propagateLabelsDiffusion(graph, labels, ...)
  } else {
    stop("Unknown method: ", method, ". Only 'solver' and 'diffusion' are supported.")
  }

  labels <- colnames(label.dist)[apply(label.dist, 1, which.max)] %>%
    stats::setNames(rownames(label.dist))

  confidence <- apply(label.dist, 1, max) %>% stats::setNames(rownames(label.dist))

  return(list(labels=labels, uncertainty=(1 - confidence), label.distribution=label.dist))
}

#' Propagate labels using Zhu, Ghahramani, Lafferty (2003) algorithm, "Semi-Supervised Learning Using Gaussian Fields and Harmonic Functions" <http://mlg.eng.cam.ac.uk/zoubin/papers/zgl.pdf>
#' 
#' @param graph igraph graph object Graph input 
#' @param labels vector of factor or character labels, named by cell names
#' @param solver Method of solver to use (default="mumps"), either "Matrix" or "mumps" (i.e. "rmumps::Rmumps")
#' @return result from Matrix::solve() or rmumps::Rmumps
#' @examples 
#' \donttest{
#' propagateLabelsSolver(conosGraph, labels=cellAnnotations)
#' }
#' @export
propagateLabelsSolver <- function(graph, labels, solver="mumps") {
  if (!solver %in% c("mumps", "Matrix")){
    stop("Unknown solver: ", solver, ". Only 'mumps' and 'Matrix' are currently supported")
  }

  if (!requireNamespace("rmumps", quietly=TRUE)) {
    warning("Package 'rmumps' is required to use 'mumps' solver. Fall back to 'Matrix'")
    solver <- "Matrix"
  }

  adj.mat <- igraph::as_adjacency_matrix(graph, attr="weight")
  labeled.cbs <- intersect(colnames(adj.mat), names(labels))
  unlabeled.cbs <- setdiff(colnames(adj.mat), names(labels))

  labels <- as.factor(labels[labeled.cbs])

  weight.sum.mat <- Matrix::Diagonal(x=Matrix::colSums(adj.mat)) %>%
    `dimnames<-`(dimnames(adj.mat))

  laplasian.uu <- (weight.sum.mat[unlabeled.cbs, unlabeled.cbs] - adj.mat[unlabeled.cbs, unlabeled.cbs])

  type.scores <- Matrix::sparseMatrix(i=1:length(labels), j=as.integer(labels), x=1.0) %>%
    `colnames<-`(levels(labels)) %>% `rownames<-`(labeled.cbs)

  right.side <- Matrix::drop0(adj.mat[unlabeled.cbs, labeled.cbs] %*% type.scores)

  if (solver == "Matrix") {
    res <- Matrix::solve(laplasian.uu, right.side)
  } else {
    res <- rmumps::Rmumps$new(laplasian.uu, copy=FALSE)$solve(right.side)
  }

  colnames(res) <- levels(labels)
  rownames(res) <- unlabeled.cbs
  return(rbind(res, type.scores))
}

#' Estimate labeling distribution for each vertex, based on provided labels using a Random Walk on graph
#'
#' @param graph igraph graph object Graph input 
#' @param labels vector of factor or character labels, named by cell names
#' @param max.iters integer Maximal number of iterations (default=100)
#' @param diffusion.fading numeric Constant used for diffusion on the graph, exp(-diffusion.fading * (edge_length + diffusion.fading.const)) (default=10.0)
#' @param diffusion.fading.const numeric Another constant used for diffusion on the graph, exp(-diffusion.fading * (edge_length + diffusion.fading.const)) (default=0.1)
#' @param tol numeric Absolute tolerance as a stopping criteria (default=0.025)
#' @param fixed.initial.labels boolean Prohibit changes of initial labels during diffusion (default=TRUE)
#' @param verbose boolean Verbose mode (default=TRUE)
#' @return matrix from input graph, with labels propagated
#' @examples 
#' propagateLabelsDiffusion(conosGraph, labels=cellAnnotations)
#'
#' @export
propagateLabelsDiffusion <- function(graph, labels, max.iters=100, diffusion.fading=10.0, diffusion.fading.const=0.1, tol=0.025, fixed.initial.labels=TRUE, verbose=TRUE) {
  if (is.factor(labels)) {
    labels <- as.character(labels) %>% stats::setNames(names(labels))
  }

  edges <- igraph::as_edgelist(graph)
  edge.weights <- igraph::edge.attributes(graph)$weight
  labels <- labels[intersect(names(labels), igraph::vertex.attributes(graph)$name)]
  label.distribution <- propagate_labels(edges, edge.weights, vert_labels=labels, max_n_iters=max.iters, verbose=verbose,
                                         diffusion_fading=diffusion.fading, diffusion_fading_const=diffusion.fading.const,
                                         tol=tol, fixed_initial_labels=fixed.initial.labels)
  return(label.distribution)
}