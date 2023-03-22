class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/25/7e/704143fd83b6d13d8d146730bd01d10b73d9eb78137f7ee52fec7ed3c594/yamllint-1.30.0.tar.gz"
  sha256 "4f58f323aedda16189a489d183ecc25c66d7a9cc0fe88f61b650fef167b13190"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ce7abb1de9cd41d661929fcbc7d85215eae1afeafe148d3fb2cc1f72d6e678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e54b87eab00c4b653aae6c11296c086a14a3b0f45c2751b586529f5c1a1d956d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8994da7382a322ef7aec71c18ac818878987a58c8e1d1722c5e7c6108cf612ce"
    sha256 cellar: :any_skip_relocation, ventura:        "3f26ac3b19e15ce2ad16a32a515dcc7ab03577a3327a9cc97b4bc543fcf73329"
    sha256 cellar: :any_skip_relocation, monterey:       "3f5fadd1eefef12870422f062355ce3b2db16958df23ee8a45b58ce4d1454a54"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cea8e16be7992edf6fb75636f412b3892e01bd07083246aaf1f5708c44ccdc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8e530006efc9ac84535e7806415de537f1d9576b2070af651bd92662767a420"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/95/60/d93628975242cc515ab2b8f5b2fc831d8be2eff32f5a1be4776d49305d13/pathspec-0.11.1.tar.gz"
    sha256 "2798de800fa92780e33acca925945e9a19a133b715067cf165b8866c15a31687"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
