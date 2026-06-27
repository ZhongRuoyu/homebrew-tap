class Shortener < Formula
  desc "Simple URL shortener"
  homepage "https://github.com/ZhongRuoyu/shortener"
  url "https://github.com/ZhongRuoyu/shortener.git",
      tag:      "v0.2.0",
      revision: "bb7489c27bf4f5caee6978bc7b38d591ce0c4329"
  license "MIT"
  head "https://github.com/ZhongRuoyu/shortener.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87b848b1170a26c09955b91da0702255d67231de94bb38f5670de067f8899c6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47022f0553c790f0c743f3a5c6bbf2ceb5124c1b53fa5814297857594871a80e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "836815946bcb817dd78fffd034ee1de8b2d169a100357e4f0872e148360d2718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3db50e8e38a108ecb9fc741d773ecea8f2370303659620ec298a7c60182828b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5321a3dfbbeacfc3814faefc6ac6bfc63d82d68b9623c6eb87231b737b2cd50"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
    bin.children.each do |binary|
      generate_completions_from_executable(binary, "completions")
    end
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/shortener --version")

    system "sqlite3", "shortener.db", "VACUUM;"

    system bin/"shortener-key", "-d", "shortener.db", "create-user", "test"
    key = shell_output("#{bin}/shortener-key -d shortener.db create-key test").chomp

    begin
      port = free_port
      shorten_args = %W[
        --auth
        --database shortener.db
        --listen-port #{port}
      ]
      pid = spawn bin/"shortener", *shorten_args

      sleep 1

      code = "brew"
      page = "https://brew.sh/"
      curl_args = [
        "-H", "Authorization: Bearer #{key}",
        "http://localhost:#{port}/#{code}",
        "-d", page
      ]
      system "curl", *curl_args
      assert_equal page, shell_output("curl http://localhost:#{port}/#{code}").chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    assert_equal page, shell_output("#{bin}/shortener-url -d shortener.db get #{code}").chomp

    dylibs = []
    dylibs << (formula_opt_lib("sqlite")/shared_library("libsqlite3")) if OS.linux?
    dylibs.each do |library|
      bin.children.each do |binary|
        assert Utils.binary_linked_to_library?(binary, library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end
