class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://github.com/ansible/ansible-lint/"
  url "https://files.pythonhosted.org/packages/98/e8/0e399e023de25053b7d2fc17a65ad1850dbcb0a9e6ee855c94d6549ee5dc/ansible-lint-5.0.6.tar.gz"
  sha256 "e5104cb11c437aec7f51e05a07f8c68d7f9b7c4cc36afc52edd8b0f71d84d63a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "62a92636a51a4ee03d14d617d101ce848e41d04ab820da4ffbf7d52152a6a5f7"
    sha256 cellar: :any, big_sur:       "be73403fab6a433811cb8a177128f9a4a14507672f7177bc7ea80d68b1be835c"
    sha256 cellar: :any, catalina:      "737674b443badbd711f4c327cff2f94077231f4437c004b2de99a1fe275d83d8"
    sha256 cellar: :any, mojave:        "1358a82563914b0a88c328af4de5afb0462e445461b6979887c32950809baa2f"
  end

  depends_on "pkg-config" => :build
  depends_on "ansible"
  depends_on "libyaml"
  depends_on "python@3.9"

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/bb/80/7118945282845f8dc337c45c7d9d171a9f86d0c7650ac7e65d60995691d2/bracex-2.1.1.tar.gz"
    sha256 "01f715cd0ed7a622ec8b32322e715813f7574de531f09b70f6f3b2c10f682425"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "enrich" do
    url "https://files.pythonhosted.org/packages/47/2b/b453d52a5cd1409d859d67c6a530971095406aedc0c0589c1c6a5212f506/enrich-1.2.6.tar.gz"
    sha256 "0e99ff57d87f7b5def0ca79917e88fb9351aa0d52e228ee38bff7cd858315fe4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ae/f6/6ffb46f6cf0bb584e44279accd3321cb838b78b324031feb8fd9adf63ed2/rich-9.13.0.tar.gz"
    sha256 "d59e94a0e3e686f0d268fe5c7060baa1bd6744abca71b45351f5850a3aaa6764"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/1d/2f/40abf6501e051df8af970bfa6d81a90fcd62dc536f82ceec80a2694a3123/ruamel.yaml-0.16.13.tar.gz"
    sha256 "bb48c514222702878759a05af96f4b7ecdba9b33cd4efcf25c86b882cef3a942"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/24/b9/51525e9aea08d04e602a53812afe3890e78d204e55464f8d0ea906587e54/wcmatch-8.1.2.tar.gz"
    sha256 "efda751de15201b395b6d6e64e6ae3b6b03dc502a64c3c908aa5cad14c27eee5"
  end

  def install
    virtualenv_install_with_resources
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    site_packages = "lib/python#{xy}/site-packages"
    ansible = Formula["ansible"].opt_libexec
    (libexec/site_packages/"homebrew-ansible.pth").write ansible/site_packages
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOS
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
