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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7fce0ffb8eafd966de064e59e04e8c105df79403f53781ba514c0fa4a15b682"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a5402214d40d95b6c47ed1199ef21e7d42bafab26ef52287cf29dedf3d3bca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7a4cc64fb4e908139eb99854dfdfd0f64e9973d0cd4f00ed619d4f0648a9301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6a5cb9bbfd65f85aca2862031e879cd4d4b62608db501c3b2ce6858b62abbe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f8e09da23cf25a1409d7158a2c7ea8ebb47d0afbeab383f4b0e65b100d1ab6"
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
