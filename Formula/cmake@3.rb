class CmakeAT3 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.12/cmake-3.31.12.tar.gz"
  mirror "https://cmake.org/files/v3.31/cmake-3.31.12.tar.gz"
  sha256 "5f3fd5a54dfa65602bdbed64f981a72673cc19f2d304cc2955cf0dfa0cfd8272"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5966c45781dced6b31e047ae094a00b3665f414107e205a48b3a5dfd5953568a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59d842fe4c29dc727a3f85c45c2a6350a8bf6abedacd81eb5357fc5388163480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56253fa5c5418404aa6b1b90483d09b45706fab104a1ddef659062023b87e19a"
    sha256 cellar: :any_skip_relocation, sequoia:       "931a13e6d523b6538c8bfb7bb1468f96da62b6fb131abc49d0e3e7196c05a3cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "489052f00707c90d82021a68e70a0d59c5a76b8a77d0b9fd70dc94b1ef61e7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acebfb5a012ce101b75ef35440ca5385f27c2801993800d9e0cd42a807fda387"
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
