class Shorten < Formula
  desc "Simple URL shortener"
  homepage "https://github.com/ZhongRuoyu/shorten"
  url "https://github.com/ZhongRuoyu/shorten.git",
      tag:      "v0.1.0",
      revision: "2e9700fe1604c11a0bd90dad82764b027618f96e"
  license "MIT"
  head "https://github.com/ZhongRuoyu/shorten.git", branch: "main"

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
