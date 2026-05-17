class CmakeDocsAT3 < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.12/cmake-3.31.12.tar.gz"
  mirror "https://cmake.org/files/v3.31/cmake-3.31.12.tar.gz"
  sha256 "5f3fd5a54dfa65602bdbed64f981a72673cc19f2d304cc2955cf0dfa0cfd8272"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "zhongruoyu/tap/cmake@3"
  end

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea9e27f3656ce0a2401e7829ce22153b7a964aee05823fcc8477adb5568b49d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1e50b4b74d74ec1092f42867bde6b00028859c2661c931e5ca8a37ffb12da98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da98824c56925fd63d550d3b0bbdb60382ef2645d0aa43e28bae2f2791a0c426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f90b1869d39c73cf46b68a98a2f98835c805b85360f3302edadf50f479c44f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1145c3a1e32d6f9f089d13b231c3a3c0223e7bf61b4828b827763b59a6aed52"
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
