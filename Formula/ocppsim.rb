class Ocppsim < Formula
  desc "Terminal OCPP-J charge point simulator"
  homepage "https://github.com/ZhongRuoyu/ocppsim"
  url "https://github.com/ZhongRuoyu/ocppsim.git",
      tag:      "v0.3.0",
      revision: "c7209b8aaddb245ef3ee65426cfeb815de929b2f"
  license "MIT"
  head "https://github.com/ZhongRuoyu/ocppsim.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cdeaa1fdfe8292ee7b78fd4e1f9d0a382655955b164a6233ce713c4a838b478"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "346dce32480112a05095025d32cc07e43dd88859f06bde2c09eede37b64f90e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9a2b32fbbeb5d6fe9370ff60b6a5a974bf7ca6196371a0b5127bbbafbacdeeb"
    sha256 cellar: :any,                 arm64_linux:   "fcd6d1d4ed31e890390113b62db21e878af2c9e22c06132acd47e962122e24e0"
    sha256 cellar: :any,                 x86_64_linux:  "e87d6c3fb5680ae41be86a166426145638f42300ded245ca440b08db1d44f633"
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
