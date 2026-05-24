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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0afc6183ef33466916f0205b717049bfac92ab93e872a45ff238d935a80b3644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52abf7563ab4681b9f8f4e79b107589fc9bbcc8c31b58edf9ecb2dbbfac89c22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b873f4c686e3569574fce013f458436ee727fa447115f375f5ae22f754948a1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b28b35e5f5544f31f5142cc7e9444d4cfabbea32fc7074d8f1efffbd4d27afee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01c6de8594529324ccc0d0e6b90d8188c4ccde56336eefb5017ca0a9716f762f"
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
    dylibs << (Formula["sqlite"].opt_lib/shared_library("libsqlite3")) if OS.linux?
    dylibs.each do |library|
      bin.children.each do |binary|
        assert Utils.binary_linked_to_library?(binary, library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end
