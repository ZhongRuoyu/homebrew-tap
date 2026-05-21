class Ocppsim < Formula
  desc "Terminal OCPP-J charge point simulator"
  homepage "https://github.com/ZhongRuoyu/ocppsim"
  url "https://github.com/ZhongRuoyu/ocppsim.git",
      tag:      "v0.1.1",
      revision: "1ce1dce441e0b299596c5342b39b5f91b1c1d75b"
  license "MIT"
  head "https://github.com/ZhongRuoyu/ocppsim.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d845f03454aef4f9964c0683a428d26f9eed68002d9dc3a2a3382719113c019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78ef8ded2394790d205a7688a45aee094bd6d3553b19e62d2d5a747c37e7b4cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c7e7b9f40d3a3ca7ed38c056a9f93cc4fe041aab6ee6e2cc1fd6d27c77d7ed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1765b0b38ccaea074a36ea49ad54accaa6146eec9a144d78111314a15075abf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79324469d63271d5643a4bb62f551116f5e533a25f50402992fbc21f6892f6f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ocppsim", "completions")
  end

  test do
    require "expect"

    assert_match version.to_s, shell_output("#{bin}/ocppsim --version")

    config_toml = testpath/"config.toml"
    config_toml.write <<~TOML
      log-path = "#{testpath}/ocppsim.log"

      [charge-points.test]
      ws-url = "ws://example.com/ocpp"
      id = "test"
    TOML

    Open3.popen2("script", "-q", "output.txt") do |stdin, stdout, wait_thr|
      stdin.puts "stty rows 80 cols 120"
      stdin.puts "#{bin}/ocppsim --config-path #{config_toml} test"
      stdout.expect "Simulator ready"
      stdin.puts "exit"
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    assert_match "Connector 1 status=Available", (testpath/"ocppsim.log").read
  end
end
