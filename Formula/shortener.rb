class Shortener < Formula
  desc "Simple URL shortener"
  homepage "https://github.com/ZhongRuoyu/shortener"
  url "https://github.com/ZhongRuoyu/shortener.git",
      tag:      "v0.1.1",
      revision: "b43a782efc79cf7598245a65617af4538819b96d"
  license "MIT"
  head "https://github.com/ZhongRuoyu/shortener.git", branch: "main"

  depends_on "rust" => :build
  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
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
