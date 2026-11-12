class Owe < Formula
  include Language::Python::Virtualenv

  desc "Bill splitter and tracker"
  homepage "https://github.com/ZhongRuoyu/owe"
  url "https://github.com/ZhongRuoyu/owe/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "ee76396fea95d67d19744f44df832165f68424c714906714115217c350c3d655"
  license "MIT"
  head "https://github.com/ZhongRuoyu/owe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any, arm64_golden_gate: "432457fb7736b7f9037b87cd3c262208c0bad9cd30fdafa02d7cfc5c2273ae56"
    sha256 cellar: :any, arm64_tahoe:       "8d2a2e0acb085f185dc9b8f64a6a500da559af702aaadb259529cbd1ddb896cf"
    sha256 cellar: :any, arm64_sequoia:     "437c6fa68164d0a934b76d24736eb113056271222bcf4bd81467a1a284c19fdb"
    sha256 cellar: :any, arm64_linux:       "1e8de61d80f9c6fdfaaa956b5796a747169a97ecbb910f0cfef4f19890449a76"
    sha256 cellar: :any, x86_64_linux:      "e9ce8a70ec5848116d35b7dc769565f365b61fabd3cbaf74021cafee35e2a1e0"
  end

  depends_on "rust" => :build # for uv_build
  depends_on "python@3.15"

  pypi_packages

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/0f/6e/a61e86e43bb6039b31a33a8f5fba76fe1cdacf3661e7b9756d4ff1b28cdc/annotated_doc-0.0.6.tar.gz"
    sha256 "7969bb69912085b2285849c0dcac0b4b374fd180c13cf10a87f284ffcf347bbf"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/5f/56/a8120250d128bed162cd73c76d45f6ef9991f3e068f62a8ee060afa3104a/annotated_types-0.8.0.tar.gz"
    sha256 "13b2beaad985e05e2d6407ee4c4f35590b11f8d693a258a561055cac8f64cab7"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/fd/11/b524cbd9bbdaca58608e4cf4053fd463417549e1959fa8d3aa18319f9555/certifi-2026.10.23.tar.gz"
    sha256 "a9895e6e2758b371e0545e321a3a8fd1fcfd9829ada8824a936dfb16aaaf36cd"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/60/39/7435269dcabb3c1b4ce1b9b03b40dae919415c258e1caa27160c22f55b9a/fastapi-0.162.4.tar.gz"
    sha256 "4abdb1ef367090678d8bc664631df432ae7a1bfe7709c37547d3606e667650e3"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b4/fc/1203d011145c98ddce3cd2f505bb54375ef8d43223053df6bfcf3c746f46/pydantic-2.14.3.tar.gz"
    sha256 "1054f237f4d4733e5a30e1e2333bd33a2004ab9ab1510bd053a9a31bb48e232d"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/9c/0f/34f9ce4ba701dd0b815033ef94d99b56f66200e578ee6052aa3ac26f064e/pydantic_core-2.50.4.tar.gz"
    sha256 "aead3b74b68396bf0feab5d57e050b730ded7df55853c1e048a87e00aaf033c6"
  end

  resource "python-telegram-bot" do
    url "https://files.pythonhosted.org/packages/ba/77/153517bb1ac1bba670c6fb1dbf09e1fd0730494b1705934e715391413a0d/python_telegram_bot-22.8.tar.gz"
    sha256 "f9d3847fcb23ee603477e442800b33bb4adf851a73e0619d2050be879decf1ef"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/ff/50/0195198eb1d75bab716bb0a813abea4cc394bfa17a92a189f021a34859af/typing_inspection-0.4.5.tar.gz"
    sha256 "7f16c411e7930dc79596d42ab44672a3fe5f60eb34b781a1647e7872363120c7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"owe", "database", "init"

    system bin/"owe", "user", "add", "alice", "Alice"
    system bin/"owe", "user", "add", "bob", "Bob"
    system bin/"owe", "user", "add", "charlie", "Charlie"

    system bin/"owe", "record", "add",
                      "--type", "DEBT",
                      "--lender", "alice",
                      "--borrower", "alice",
                      "--borrower", "bob",
                      "--borrower", "charlie",
                      "--amount", "15",
                      "--created-by", "alice",
                      "--remarks", "Dinner"

    output = shell_output("#{bin}/owe record summary --format json")
    records = JSON.parse(output)
    assert_equal 2, records.size
    %w[bob charlie].each do |borrower|
      assert (
        records.any? do |record|
          record["from"] == borrower &&
          record["to"] == "alice" &&
          record["amount"] == 500
        end
      )
    end
  end
end
