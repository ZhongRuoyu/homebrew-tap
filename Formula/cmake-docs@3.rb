class CmakeDocsAT3 < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.8/cmake-3.31.8.tar.gz"
  mirror "https://cmake.org/files/v3.31/cmake-3.31.8.tar.gz"
  sha256 "e3cde3ca83dc2d3212105326b8f1b565116be808394384007e7ef1c253af6caa"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "zhongruoyu/tap/cmake@3"
  end

  keg_only :versioned_formula

  depends_on "sphinx-doc" => :build
  depends_on "zhongruoyu/tap/cmake@3" => :build

  def install
    args = %w[
      -DCMAKE_DOC_DIR=share/doc/cmake
      -DCMAKE_MAN_DIR=share/man
      -DSPHINX_MAN=ON
      -DSPHINX_HTML=ON
    ]
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
