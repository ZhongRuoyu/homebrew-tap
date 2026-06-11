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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff56984cfd7211438ab20812a24e4f142387deaaef5cc5e776a6c93fff502e03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70359ad8df98f50e9fc07ea261b7e57b022fd756e3291e215d1cfe7261e1110b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75fc4ec858ff7cbe5946811ec643314eed1d5befc686ba484d2d3d59ee882dbe"
    sha256 cellar: :any,                 arm64_linux:   "30459d61edb5452cdc0397d0c648dae9a13a2c08c3708e98bc6b26dfdbff9411"
    sha256 cellar: :any,                 x86_64_linux:  "047d7a15807cb94469b734a0f8f46a9e61fd833d94c45213a873fa3e2c51a66e"
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
