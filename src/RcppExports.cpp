// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// fast_unpack_info
List fast_unpack_info(StringVector strings, StringVector names);
RcppExport SEXP _JACUSA2helper_fast_unpack_info(SEXP stringsSEXP, SEXP namesSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< StringVector >::type strings(stringsSEXP);
    Rcpp::traits::input_parameter< StringVector >::type names(namesSEXP);
    rcpp_result_gen = Rcpp::wrap(fast_unpack_info(strings, names));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_JACUSA2helper_fast_unpack_info", (DL_FUNC) &_JACUSA2helper_fast_unpack_info, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_JACUSA2helper(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
