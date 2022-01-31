// [[Rcpp::plugins("cpp11")]]

#include <Rcpp.h>
#include <string>
#include <iostream>
#include <sstream>
#include <map>

using namespace Rcpp;

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp 
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//


char EMPTY = '*';

//' Fast unpack info.
//' 
//' @param strings Vector of string to unpack
//' @param names Vector os strings of keys to unpacks
//' @returns List of unpacked values
//' 
//' @export
// [[Rcpp::export]]
List fast_unpack_info(StringVector strings, StringVector names) {
  int row_count = strings.size();
  int col_count = names.size();
  // containers for values
  List l(col_count);
  // init
  for (int i = 0; i < col_count; ++i) {
    l[i] = StringVector(row_count);
  }
  l.attr("names") = names;
  // parse
  for (int i = 0; i < row_count; ++i) {
    std::string s = as<std::string>(strings[i]);
    if (s.size() == 0 || s[0] == EMPTY) {
      continue; 
    }
    
    std::string key_value;
    std::string key;
    int start = 0;
    int middle;
    int end;
    do {
      end = s.find_first_of(";", start);
      key_value = s.substr(start, end - start);
      middle = key_value.find_first_of("=", 0);
      key = key_value.substr(0, middle).c_str();
      if (l.containsElementNamed(key.c_str())) {      
        StringVector v = l[key.c_str()];
        v[i] = key_value.substr(middle + 1).c_str();
      }
      start = end + 1;
    } while (end != std::string::npos);
  }
  
  return l;
}
