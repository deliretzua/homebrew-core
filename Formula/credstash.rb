class Credstash < Formula
  include Language::Python::Virtualenv

  desc "Little utility for managing credentials in the cloud"
  homepage "https://github.com/fugue/credstash"
  url "https://files.pythonhosted.org/packages/b4/89/f929fda5fec87046873be2420a4c0cb40a82ab5e30c6d9cb22ddec41450b/credstash-1.17.1.tar.gz"
  sha256 "6c04e8734ef556ab459018da142dd0b244093ef176b3be5583e582e9a797a120"
  license "Apache-2.0"
  revision 7
  head "https://github.com/fugue/credstash.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "82841d16ce017c7272ac0c5160b23010dc5558cb9919d97a9e0ef26e02329c1e"
    sha256 cellar: :any,                 arm64_monterey: "e97f61eff12595dc7dc6064635b144546e42eb855b1c4301276277840c387b31"
    sha256 cellar: :any,                 arm64_big_sur:  "4b6fddd1a14693c8e6bf13bcd997554968297d081f817f818168ce999af7bd21"
    sha256 cellar: :any,                 ventura:        "ecde54174470b7641081d5ddc90c58c964c24f09b21b0067aa68112aeeef2799"
    sha256 cellar: :any,                 monterey:       "6add1797c2fd0d1a3b9f2f3e93b7d1cc4149965cdae81952193afa323f28a384"
    sha256 cellar: :any,                 big_sur:        "308e43a98e73440470ddb51db4b70f285d34c74243197441eb4a681c93ba5182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad46d88c67d708714e42ce489050d3b9696c56ea86fb1cd28522b39d4f0755f"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b5/3e/585a02252bcedbaed06d8f01c25aadcb75e5569804c3eee729315d64a4f7/boto3-1.28.3.tar.gz"
    sha256 "610369a7f984b58973c097ea649ec81976c04565d39a2d6d3edc280d23b0cb87"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/bd/26/62d5fdbf4d03e46e0ed5a280bd81eab4c600abe14e50ac5c9a823fd2ca1e/botocore-1.31.3.tar.gz"
    sha256 "744ce853cadc7ae87ba42ef6828194ddec97d606dd4d08b4dfe3d96d5001eb0c"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/93/b7/b6b3420a2f027c1067f712eb3aea8653f8ca7490f183f9917879c447139b/cryptography-41.0.2.tar.gz"
    sha256 "7d230bf856164de164ecb615ccc14c7fc6de6906ddd5b491f3af90d3514c925c"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    output = shell_output("#{bin}/credstash put test test 2>&1", 1)
    assert_match "Could not generate key using KMS key", output
  end
end
