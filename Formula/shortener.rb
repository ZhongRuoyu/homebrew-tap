class Shortener < Formula
  desc "Simple URL shortener"
  homepage "https://github.com/ZhongRuoyu/shortener"
  url "https://github.com/ZhongRuoyu/shortener.git",
      tag:      "v0.2.1",
      revision: "e22b1590e5ac115d76c84c428c39b35ce19ceaf6"
  license "MIT"
  head "https://github.com/ZhongRuoyu/shortener.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ddf7cef52d0e699689edaaa07df5ab49ad20cfb215ff78cd80c9969cd8fd855"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ffd68c7a1cc86e91891d1b03fe474fdcfbae8b285ea4b36e556498ff7ea7b536"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f707b26e4d77d1454986cb6a6d86694acaac4861a04d8a5428538f943c4e3c8"
    sha256 cellar: :any,                 arm64_linux:       "4ab44dc565833023e9172093cb91e6dc4a62764739505467d1099b77ff058634"
    sha256 cellar: :any,                 x86_64_linux:      "26adacb4f37c24fa3e0d0c61acc2a077164cbe352dc5b536357dc6ad736bae01"
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
