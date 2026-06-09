class Owe < Formula
  include Language::Python::Virtualenv

  desc "Bill splitter and tracker"
  homepage "https://github.com/ZhongRuoyu/owe"
  url "https://github.com/ZhongRuoyu/owe/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6652f8f14a6d5abfc3468d344832e21224e23fa3a3529d1056e9075075fd1968"
  license "MIT"
  head "https://github.com/ZhongRuoyu/owe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/zhongruoyu/zhongruoyu-homebrew-tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53ae4dc056c99f893f1f27d151a6238d169b49b4e366cfdb9a9ae66ae71ae854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5778a3ce834ca2bfe018d936d65932a226731d12037cd173087a3c55287d00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64447438d4a823996921747ea3f3aeaf641777b8c85685fef648cf35c55f5701"
    sha256 cellar: :any,                 arm64_linux:   "c786056cc6a0c7ffde6bb2c271dbab9f548d1805f1573fb22fa1680d4598dcdf"
    sha256 cellar: :any,                 x86_64_linux:  "8f4e2cf5276076a142288b08c0d717a1a0e7981efcf16b59f602a01fbfc66488"
  end

  depends_on "rust" => :build # for uv_build
  depends_on "python@3.14"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/f3/ce/ee2ecad540810a79593028e88299baeae54d346cc7a0d94b6199988b89b1/certifi-2026.5.20.tar.gz"
    sha256 "69dea482ab64caa7b9f6aba1c6bf48bb6a5448d1c0f1b17ab42ad8c763a5344d"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/81/2d/ff8d91d7b564d464629a0fd50a4489c97fcb836ac230bf3a7269232a9b1f/fastapi-0.136.3.tar.gz"
    sha256 "e487fae93ad408e6f47641ee4dfe389864fd7bec92e547ea8498fc13f43e83ab"
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
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/18/a5/b60d21ac674192f8ab0ba4e9fd860690f9b4a6e51ca5df118733b487d8d6/pydantic-2.13.4.tar.gz"
    sha256 "c40756b57adaa8b1efeeced5c196f3f3b7c435f90e84ea7f443901bec8099ef6"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/9d/56/921726b776ace8d8f5db44c4ef961006580d91dc52b803c489fafd1aa249/pydantic_core-2.46.4.tar.gz"
    sha256 "62f875393d7f270851f20523dd2e29f082bcc82292d66db2b64ea71f64b6e1c1"
  end

  resource "python-telegram-bot" do
    url "https://files.pythonhosted.org/packages/e4/25/2258161b1069e66d6c39c0a602dbe57461d4767dc0012539970ea40bc9d6/python_telegram_bot-22.7.tar.gz"
    sha256 "784b59ea3852fe4616ad63b4a0264c755637f5d725e87755ecdee28300febf61"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/25/44/ec35f1b6e83094b997da438a02c8c9b0ade2b1e84cfc48bd4656780760a6/starlette-1.2.1.tar.gz"
    sha256 "9b9b5ebb992e67d6093741e63c2f59e4f6fff986f81163c087867bd7b924b3f6"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
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
