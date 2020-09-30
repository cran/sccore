// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <RcppEigen.h>
#include <Rcpp.h>

using namespace Rcpp;

// colSumByFac
arma::mat colSumByFac(SEXP sY, SEXP rowSel);
RcppExport SEXP _sccore_colSumByFac(SEXP sYSEXP, SEXP rowSelSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< SEXP >::type sY(sYSEXP);
    Rcpp::traits::input_parameter< SEXP >::type rowSel(rowSelSEXP);
    rcpp_result_gen = Rcpp::wrap(colSumByFac(sY, rowSel));
    return rcpp_result_gen;
END_RCPP
}
// as_factor
Rcpp::List as_factor(const std::vector<std::string>& vals);
RcppExport SEXP _sccore_as_factor(SEXP valsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<std::string>& >::type vals(valsSEXP);
    rcpp_result_gen = Rcpp::wrap(as_factor(vals));
    return rcpp_result_gen;
END_RCPP
}
// get_nearest_neighbors
Rcpp::List get_nearest_neighbors(const std::vector<std::vector<int>>& adjacency_list, const std::vector<std::vector<double>>& transition_probabilities, int n_verts, int n_cores, double min_prob, int min_visited_verts, double min_prob_lower, int max_hitting_nn_num, int max_commute_nn_num, bool verbose);
RcppExport SEXP _sccore_get_nearest_neighbors(SEXP adjacency_listSEXP, SEXP transition_probabilitiesSEXP, SEXP n_vertsSEXP, SEXP n_coresSEXP, SEXP min_probSEXP, SEXP min_visited_vertsSEXP, SEXP min_prob_lowerSEXP, SEXP max_hitting_nn_numSEXP, SEXP max_commute_nn_numSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<std::vector<int>>& >::type adjacency_list(adjacency_listSEXP);
    Rcpp::traits::input_parameter< const std::vector<std::vector<double>>& >::type transition_probabilities(transition_probabilitiesSEXP);
    Rcpp::traits::input_parameter< int >::type n_verts(n_vertsSEXP);
    Rcpp::traits::input_parameter< int >::type n_cores(n_coresSEXP);
    Rcpp::traits::input_parameter< double >::type min_prob(min_probSEXP);
    Rcpp::traits::input_parameter< int >::type min_visited_verts(min_visited_vertsSEXP);
    Rcpp::traits::input_parameter< double >::type min_prob_lower(min_prob_lowerSEXP);
    Rcpp::traits::input_parameter< int >::type max_hitting_nn_num(max_hitting_nn_numSEXP);
    Rcpp::traits::input_parameter< int >::type max_commute_nn_num(max_commute_nn_numSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    rcpp_result_gen = Rcpp::wrap(get_nearest_neighbors(adjacency_list, transition_probabilities, n_verts, n_cores, min_prob, min_visited_verts, min_prob_lower, max_hitting_nn_num, max_commute_nn_num, verbose));
    return rcpp_result_gen;
END_RCPP
}
// jsDist
arma::mat jsDist(const arma::mat& m, int ncores);
RcppExport SEXP _sccore_jsDist(SEXP mSEXP, SEXP ncoresSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type m(mSEXP);
    Rcpp::traits::input_parameter< int >::type ncores(ncoresSEXP);
    rcpp_result_gen = Rcpp::wrap(jsDist(m, ncores));
    return rcpp_result_gen;
END_RCPP
}
// propagate_labels
Rcpp::NumericMatrix propagate_labels(const Rcpp::StringMatrix& edge_verts, const std::vector<double>& edge_weights, const Rcpp::StringVector& vert_labels, int max_n_iters, bool verbose, double diffusion_fading, double diffusion_fading_const, double tol, bool fixed_initial_labels);
RcppExport SEXP _sccore_propagate_labels(SEXP edge_vertsSEXP, SEXP edge_weightsSEXP, SEXP vert_labelsSEXP, SEXP max_n_itersSEXP, SEXP verboseSEXP, SEXP diffusion_fadingSEXP, SEXP diffusion_fading_constSEXP, SEXP tolSEXP, SEXP fixed_initial_labelsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const Rcpp::StringMatrix& >::type edge_verts(edge_vertsSEXP);
    Rcpp::traits::input_parameter< const std::vector<double>& >::type edge_weights(edge_weightsSEXP);
    Rcpp::traits::input_parameter< const Rcpp::StringVector& >::type vert_labels(vert_labelsSEXP);
    Rcpp::traits::input_parameter< int >::type max_n_iters(max_n_itersSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< double >::type diffusion_fading(diffusion_fadingSEXP);
    Rcpp::traits::input_parameter< double >::type diffusion_fading_const(diffusion_fading_constSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< bool >::type fixed_initial_labels(fixed_initial_labelsSEXP);
    rcpp_result_gen = Rcpp::wrap(propagate_labels(edge_verts, edge_weights, vert_labels, max_n_iters, verbose, diffusion_fading, diffusion_fading_const, tol, fixed_initial_labels));
    return rcpp_result_gen;
END_RCPP
}
// smooth_count_matrix
SEXP smooth_count_matrix(const Rcpp::StringMatrix& edge_verts, const std::vector<double>& edge_weights, const Rcpp::NumericMatrix& count_matrix, const std::vector<bool>& is_label_fixed, int max_n_iters, double diffusion_fading, double diffusion_fading_const, double tol, bool verbose, bool normalize);
RcppExport SEXP _sccore_smooth_count_matrix(SEXP edge_vertsSEXP, SEXP edge_weightsSEXP, SEXP count_matrixSEXP, SEXP is_label_fixedSEXP, SEXP max_n_itersSEXP, SEXP diffusion_fadingSEXP, SEXP diffusion_fading_constSEXP, SEXP tolSEXP, SEXP verboseSEXP, SEXP normalizeSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const Rcpp::StringMatrix& >::type edge_verts(edge_vertsSEXP);
    Rcpp::traits::input_parameter< const std::vector<double>& >::type edge_weights(edge_weightsSEXP);
    Rcpp::traits::input_parameter< const Rcpp::NumericMatrix& >::type count_matrix(count_matrixSEXP);
    Rcpp::traits::input_parameter< const std::vector<bool>& >::type is_label_fixed(is_label_fixedSEXP);
    Rcpp::traits::input_parameter< int >::type max_n_iters(max_n_itersSEXP);
    Rcpp::traits::input_parameter< double >::type diffusion_fading(diffusion_fadingSEXP);
    Rcpp::traits::input_parameter< double >::type diffusion_fading_const(diffusion_fading_constSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< bool >::type normalize(normalizeSEXP);
    rcpp_result_gen = Rcpp::wrap(smooth_count_matrix(edge_verts, edge_weights, count_matrix, is_label_fixed, max_n_iters, diffusion_fading, diffusion_fading_const, tol, verbose, normalize));
    return rcpp_result_gen;
END_RCPP
}
// adjacentVertices
Rcpp::List adjacentVertices(const Rcpp::StringMatrix& edge_verts);
RcppExport SEXP _sccore_adjacentVertices(SEXP edge_vertsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const Rcpp::StringMatrix& >::type edge_verts(edge_vertsSEXP);
    rcpp_result_gen = Rcpp::wrap(adjacentVertices(edge_verts));
    return rcpp_result_gen;
END_RCPP
}
// adjacent_vertex_weights
Rcpp::List adjacent_vertex_weights(const Rcpp::StringMatrix& edge_verts, const std::vector<double>& edge_weights);
RcppExport SEXP _sccore_adjacent_vertex_weights(SEXP edge_vertsSEXP, SEXP edge_weightsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const Rcpp::StringMatrix& >::type edge_verts(edge_vertsSEXP);
    Rcpp::traits::input_parameter< const std::vector<double>& >::type edge_weights(edge_weightsSEXP);
    rcpp_result_gen = Rcpp::wrap(adjacent_vertex_weights(edge_verts, edge_weights));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_sccore_colSumByFac", (DL_FUNC) &_sccore_colSumByFac, 2},
    {"_sccore_as_factor", (DL_FUNC) &_sccore_as_factor, 1},
    {"_sccore_get_nearest_neighbors", (DL_FUNC) &_sccore_get_nearest_neighbors, 10},
    {"_sccore_jsDist", (DL_FUNC) &_sccore_jsDist, 2},
    {"_sccore_propagate_labels", (DL_FUNC) &_sccore_propagate_labels, 9},
    {"_sccore_smooth_count_matrix", (DL_FUNC) &_sccore_smooth_count_matrix, 10},
    {"_sccore_adjacentVertices", (DL_FUNC) &_sccore_adjacentVertices, 1},
    {"_sccore_adjacent_vertex_weights", (DL_FUNC) &_sccore_adjacent_vertex_weights, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_sccore(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}