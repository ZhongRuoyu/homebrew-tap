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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5957478a47a8b52319bc564bf8ba7b961b343e33eaaa0b72ee15226b58e52af2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3695d7a003f249737c9d02a58e5bd5bb0c13518d69c75a15a483950c0ae82469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb5ffd915defd9e982d189bf33b797723856c1602db91ad00fcd41c8069934f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0280061ec10c97bc6a1230fa46f0b02ea8e5cf9210c36370bf30b550d3e92f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d76141b4dfdca25a91995472bab221af4d2c6bc573938639133e827e6ce77ee"
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
