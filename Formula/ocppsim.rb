class Ocppsim < Formula
  desc "Terminal OCPP-J charge point simulator"
  homepage "https://github.com/ZhongRuoyu/ocppsim"
  url "https://github.com/ZhongRuoyu/ocppsim.git",
      tag:      "v0.4.0",
      revision: "15f69d835dd77ca032a2af2aa45dad6247a32a16"
  license "MIT"
  head "https://github.com/ZhongRuoyu/ocppsim.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86ddfdb7b832daa7b3fa95db6d3806fa65079d995473ed71bc4fb2f9f5c1cf59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2aaa474b79a2bcf823e070fb95ae8520dcfde6d53975d43dc22adf4f5ff7b41b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b420a0aab47ad0d138218bc1810c19b8504d921b4436f0071d3d11b12427dc4"
    sha256 cellar: :any,                 arm64_linux:       "452f67dad4ef284e3b97c1b4d5013f1c773490b62b4ca222c0eb66f842753184"
    sha256 cellar: :any,                 x86_64_linux:      "85432a49e19f58f67e63a88c698925a6df97ff38c9a233ae926820f28f6a95f5"
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
