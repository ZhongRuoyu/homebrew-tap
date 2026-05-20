class Shortener < Formula
  desc "Simple URL shortener"
  homepage "https://github.com/ZhongRuoyu/shortener"
  url "https://github.com/ZhongRuoyu/shortener.git",
      tag:      "v0.1.2",
      revision: "f4f386661f92acbbf7907d1c379427923980b7fd"
  license "MIT"
  head "https://github.com/ZhongRuoyu/shortener.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0a94f0721658030bebc906783326c80e4579e78211cde1ef5087ff685b83123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ef3c871bbe1e5750cf6661bfde4742569e72a8f02262e40c9502a9706bcfe48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59099c25f92521a0081c101f427d438ef0d5e85b51f18f5059d6ae5ea5aef9b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9489b8cdda10498488deaa432be5a25f4cc6382d037d96e0774c54666d7e3f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4beb10135c547c620b04ac1fcf10ea4ba3d1df905c741d198ed96b2f673a0c3"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"shortener", "completions")
    generate_completions_from_executable(bin/"shortenerkey", "completions")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/shortener --version")

    system "sqlite3", "shortener.db", "VACUUM;"

    system bin/"shortenerkey", "-d", "shortener.db", "create-user", "test"
    key = shell_output("#{bin}/shortenerkey -d shortener.db create-key test").chomp

    begin
      port = free_port
      shorten_args = %W[
        --auth
        --sqlite-db shortener.db
        --listen-port #{port}
      ]
      pid = spawn bin/"shortener", *shorten_args

      sleep 1

      page = "https://brew.sh/"
      curl_args = [
        "-H", "Authorization: Bearer #{key}",
        "http://localhost:#{port}/brew",
        "-d", page
      ]
      system "curl", *curl_args
      assert_equal page, shell_output("curl http://localhost:#{port}/brew").chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    dylibs = []
    dylibs << (Formula["sqlite"].opt_lib/shared_library("libsqlite3")) if OS.linux?
    dylibs.each do |library|
      [bin/"shortener", bin/"shortenerkey"].each do |binary|
        assert Utils.binary_linked_to_library?(binary, library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end
