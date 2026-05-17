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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "160bfe46ff674206ad784654bc0def556804a05017d48be0d8878148b582b4d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06dd84c6ea24f3661ea613d8f5147f30319475509d4d1ea31754361aa28b70c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b1cdd01c70cc0a0246bfab53888a424e140908d44256dd12380247556cbb756"
    sha256 cellar: :any_skip_relocation, tahoe:         "029fd1dca77e75f675d77fc96fffca49e0e92f223474b6f2fe0d23bef64b39ff"
    sha256 cellar: :any_skip_relocation, sequoia:       "c61f8f4ff59d549c238b2fa6ed5f8cfba349b3eaf4a6c624cfb5ddeb7cbf8a32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eb2aa280a98a26cdd795bb81ed0d52eda8fa770302f99944b400e07bab67334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2a8c30c8769f0110992162e57a990a3524b95a072d32179d598ab7e81e17935"
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
