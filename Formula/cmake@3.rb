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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20fe3b56ef13a52749c79c5c850ae1c97cc85a453ba123321b11d9f8d36e1910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03e0b157255571aed9239641148bb85ef40de5d4b9dc7bff3cabaae59dd793f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "678fe21a088050c1bb7b04f43a07e08b5a16b311cefb2901dd3c560f40527e42"
    sha256 cellar: :any_skip_relocation, sequoia:       "757912bcc391a9c9349787f5e90c011f17ec3789caf3e477228f781c0730fe20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0559866dc1853e5bdd3658da20f619ffb158612dc11ab5f53afeb985977d2f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b86b7be0980277ebd5cc4f9a0b243801f5a3f87af079e98bb3a7e7786e9df23"
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
