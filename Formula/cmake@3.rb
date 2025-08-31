class CmakeAT3 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.8/cmake-3.31.8.tar.gz"
  mirror "https://cmake.org/files/v3.31/cmake-3.31.8.tar.gz"
  sha256 "e3cde3ca83dc2d3212105326b8f1b565116be808394384007e7ef1c253af6caa"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c509188a70fbd5c89a3055054c37d27ef468dd58d46c19213780c1560fdec77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bfdf0de74f10e349764035c607dd86c35f1e287107f5898e3ca351d5d235c97"
    sha256 cellar: :any_skip_relocation, ventura:       "a0e79f88f2191481dc6cf10f66f85849761877b9f69625bc411403a9bb35bdae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df6a96ed75444d505c39d72258662dab8d890b0516ea5fa668a343b5d75de344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc226a9a88da5f0ba67df51ee2b3a4bc5c15354f1dd2568b25f64c2c551b4cfe"
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
