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

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f603f14e1e6f2526270138a2bd24f6d48103d2747fdab246b0a09d5dcc91e5cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "923cb8aa25b1041288896a4a8b93046fe3325a6c9ae982c0de822c1c77eac47b"
    sha256 cellar: :any_skip_relocation, ventura:       "6e01e3cdbaa11e9fc36ad900e49350c390be4f31c2df67b4e406abd7fe5ce342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97d9e803fea1de7f0b7df1bcf746b5e307bd163a63825ef5632c3a4e795daf06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "189ee6f097f8beb823d8f8631ef9aa072fdf27299497186048ae53ad2fe36ff7"
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
