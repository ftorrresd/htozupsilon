#include "pybind11/pybind11.h"

#include <ROOT/RDataFrame.hxx>
#include <ROOT/RVec.hxx>

#include <iostream>

#include "htozupsilon.hpp"

#define STRINGIFY(x) #x
#define MACRO_STRINGIFY(x) STRINGIFY(x)

namespace py = pybind11;

PYBIND11_MODULE(_core, m) {
  m.doc() = R"pbdoc(
        Pybind11 example plugin
        -----------------------

        .. currentmodule:: scikit_build_example

        .. autosummary::
           :toctree: _generate

           add
           subtract
    )pbdoc";

  m.def("add", &add, R"pbdoc(
        Add two numbers

        Some other explanation about the add function.
    )pbdoc");

  m.def("run", [](const std::string input_file) {
    std::cout << "Processing: " << input_file << std::endl;

    ROOT::EnableImplicitMT();

    auto df = ROOT::RDataFrame("Events", input_file);

    auto sum = 0.;
    df.Foreach(
        [&](ROOT::RVec<float> Muon_pt) { sum += ROOT::VecOps::Sum(Muon_pt); },
        {"Muon_pt"});

    printf("Sum: %f\n", sum);
  });

#ifdef VERSION_INFO
  m.attr("__version__") = MACRO_STRINGIFY(VERSION_INFO);
#else
  m.attr("__version__") = "dev";
#endif
}
