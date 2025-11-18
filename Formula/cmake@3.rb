class CmakeAT3 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.10/cmake-3.31.10.tar.gz"
  mirror "https://cmake.org/files/v3.31/cmake-3.31.10.tar.gz"
  sha256 "cf06fadfd6d41fa8e1ade5099e54976d1d844fd1487ab99942341f91b13d3e29"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a418e84c182de2dd5bc61eb12b681ea0a158eb782096eee85e1f8a6ec5a950dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0dcf2207b87d4801d56ee3f47e70825b79ae7763a45881c713bb689e3a4500e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "530a6b805c40b1b60f93eb2a1222380411996623a1f4268eeb67cf3a3336152c"
    sha256 cellar: :any_skip_relocation, sequoia:       "fe96c5fd05ca603c4f1e884549e631a30a6e7b3e06cd09900116b18a727e230f"
    sha256 cellar: :any_skip_relocation, ventura:       "bf8c5389ea530982da559ffe2ea219e50847e77a07c6b9d3979c2cb2aaa317f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25e199d09bf9630fc18dfb5135ae275f2c51ca5622736e215d6ed8707fc9a0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8effccead207d73f6a52c88c2d6b6cad2a76b9ce460aa53711fa7f23576367c0"
  end

  keg_only :versioned_formula

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :high_sierra

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install #{tap.name}/cmake-docs@3
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{version.major_minor})
      find_package(Ruby)
    CMAKE
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
