class Sail < Formula
  include Language::Python::Virtualenv

  desc "CLI toolkit to provision and deploy WordPress applications to DigitalOcean"
  homepage "https://sailed.io"
  url "https://files.pythonhosted.org/packages/7c/b7/ec76c2bd43ee0486b3e912aa541865254b4e48a8afc6bf337cf2ce84d082/sailed.io-0.9.18.tar.gz"
  sha256 "2456c36405d51b151cd930c85add1c41482902670351cc1b23a6e33489dee823"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c321a33e8a0911a1fd62dd77520f06dd952bf8611dd14d272a8b33da95735dc7"
    sha256 cellar: :any,                 arm64_big_sur:  "6aac22eb1676646dee22b1ce34df0da39a5f44e50399b2743f259f0c365ee1a3"
    sha256 cellar: :any,                 monterey:       "5decf083adfe0a328208cfe95a0f3bacd3d5e764bc086ce01ce8f04aea08283b"
    sha256 cellar: :any,                 big_sur:        "a34aaa72c7f573a1bf35284a246f9b0593499cf5e08347a5dbc61ffe09bf121d"
    sha256 cellar: :any,                 catalina:       "cd8b151a140744fe5a650d97262553374da0487ac59286b3d2caeee8b4b06d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85bf149225d57f8e43a9f46d24c09e90d873f3c8d5d520c3e9b135079e1079b9"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/91/90b8d4cd611ac2aa526290ae4b4285aa5ea57ee191c63c2f3d04170d7683/cryptography-35.0.0.tar.gz"
    sha256 "9933f28f70d0517686bd7de36166dda42094eac49415459d9bdf5e7df3e0086d"
  end

  resource "fabric" do
    url "https://files.pythonhosted.org/packages/32/61/9a26b8f3dcdb5cb17daff57c9a85be6d5963d50488f45319d64a413da762/fabric-2.6.0.tar.gz"
    sha256 "47f184b070272796fd2f9f0436799e18f2ccba4ee8ee587796fca192acd46cd2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/37/b3/0b88358ee07789688d17ec7074a656da68ced50a122183187be12928b535/invoke-1.6.0.tar.gz"
    sha256 "374d1e2ecf78981da94bfaf95366216aaec27c2d6a7b7d5818d92da55aa258d3"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/dd/67/6b3a5f3d730b15b5ff77d13e6f05f9189ae44d8a8bad4967d16694eaac8b/paramiko-2.8.0.tar.gz"
    sha256 "e673b10ee0f1c80d46182d3af7751d033d9b573dd7054d2d0aa46be186c3c1d2"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/00/8d/95441120aa870aa800f8b4c6cf650bf0739d7a41883fe81769ab593556c9/prettytable-2.2.0.tar.gz"
    sha256 "bd81678c108e6c73d4f1e47cd4283de301faaa6ff6220bcd1d4022038c56b416"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    xy = Language::Python.major_minor_version "#{libexec}/bin/python"
    unittest = "#{libexec}/bin/python -m unittest discover "\
               "#{libexec}/lib/python#{xy}/site-packages/sail/tests 2>&1"

    assert_match(version.to_s, shell_output("#{bin}/sail --version"))
    assert_match("Could not parse .sail/config.json", shell_output("#{bin}/sail deploy 2>&1", 1))
    assert_match("OK", shell_output(unittest))
  end
end
