class Shorten < Formula
  desc "Simple URL shortener"
  homepage "https://github.com/ZhongRuoyu/shorten"
  url "https://github.com/ZhongRuoyu/shorten.git",
      tag:      "v0.1.0",
      revision: "2e9700fe1604c11a0bd90dad82764b027618f96e"
  license "MIT"
  head "https://github.com/ZhongRuoyu/shorten.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ec87e51e98c0cc91fc84574059e1080cbe0afc9ad84aced93f981b2832e000c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bb9f601691d6a75535cfeb44ffbf5ac318b573fe72a487c56c5c826868dfd99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1b149188fc8e8f0e6da67a3cc293a4b48014f573117cba2e4864d0f2cb49128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04562d25f3152d66c432b0c6831c491fb2d9185e055795e97c0d343c5a452ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ffe54fca010e6f6d30bda27c3739f7c41ada70c12840a9cc175630b9cc8477"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/shorten --version")

    system "sqlite3", "shorten.db", "VACUUM;"

    system bin/"shortenkey", "-d", "shorten.db", "create-user", "test"
    key = shell_output("#{bin}/shortenkey -d shorten.db create-key test").chomp

    begin
      port = free_port
      shorten_args = %W[
        --auth
        --sqlite-db shorten.db
        --listen-port #{port}
      ]
      pid = spawn bin/"shorten", *shorten_args

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
      [bin/"shorten", bin/"shortenkey"].each do |binary|
        assert Utils.binary_linked_to_library?(binary, library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end
