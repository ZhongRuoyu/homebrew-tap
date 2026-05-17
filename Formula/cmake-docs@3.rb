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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "286bbdef8b7f739bf93f0ab2c99b9e02d106e773c946d750a54cc8f31745f0a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac830d0a1934beaf30cc04ffae246989487373d92176923350b0d4f92302ee3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00b72f982eb944b73ebd28c38baa92377a426661bf3aeeb4d7d3ad5cc29ca27a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f120a2510c57055f8629ce46f356256637f751a68737665b6e1fa02d9dd448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f42037fd269688c67b0ff4502f20a3f9a42e78308497349e3fdf999aeff344"
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
