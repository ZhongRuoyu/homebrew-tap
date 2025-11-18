class CmakeDocsAT3 < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.10/cmake-3.31.10.tar.gz"
  mirror "https://cmake.org/files/v3.31/cmake-3.31.10.tar.gz"
  sha256 "cf06fadfd6d41fa8e1ade5099e54976d1d844fd1487ab99942341f91b13d3e29"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "zhongruoyu/tap/cmake@3"
  end

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ff59b5cec5457be8257527e7b231812496d644013463f729019da3ce8aa8caa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71319720671c9a84c04e3c92516a1885ed7cea5231c3a2bac32ac9612363067e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99dcfdce95307ed2f1314e85fc7d30c996b7bca77d72aa3a1641153f7accc3b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caaf228831d9124ca310415298c5f480328bb98c332fe83bc9eee1ec88f068e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c4713b8124a55846831f62aff1423f4b6269c6d7d0d1246b75ec3499c3a8ab"
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
