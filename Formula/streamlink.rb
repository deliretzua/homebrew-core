class Streamlink < Formula
  include Language::Python::Virtualenv

  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://files.pythonhosted.org/packages/0b/ce/846186c9f11d75e10c68df1bfdd1b451b142e9aa05ecd79d315824795ef3/streamlink-5.0.0.tar.gz"
  sha256 "eb66819cacfb55e766f70275b467a91693ef5e1a253017d65377f18b0e810d1b"
  license "BSD-2-Clause"
  head "https://github.com/streamlink/streamlink.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e77cc38fbc125e4f5a01d0d3f24c2644c2963a54fa037f55aec3b6dbb9e083ba"
    sha256 cellar: :any,                 arm64_big_sur:  "08e6602004e30fb7840eb8c4caca7a40c75d31c283769193a7e3df017334b6a6"
    sha256 cellar: :any,                 monterey:       "07f8b5a45ec08af9cd622b80e578f86afa3720e453b4a90d67b5abdbd943c4b4"
    sha256 cellar: :any,                 big_sur:        "c76398b1db8c18b549f2102dbd510d78e1e64ceedd5d35b81fb77424a12350ad"
    sha256 cellar: :any,                 catalina:       "3cba569bb5c14ecbeb53363b84f201d5cfe83c11e46e748e0ed4d14075477ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4df12d0735598cf902cf5cc6b99ddb4301f71c8b8f7288f79d607b1d970aeff"
  end

  depends_on "libxml2" # https://github.com/Homebrew/homebrew-core/issues/98468
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/ca/48/88ec470f8b68319b6782ca3a0570789886ad5ca24c1af2f3771699135baa/certifi-2022.9.14.tar.gz"
    sha256 "36973885b9542e6bd01dea287b2b4b3b21236307c56324fcc3f1160f2d655ed5"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/33/24/033604d30f6cf82d661c0f9dfc2c71d52cafc2de516616f80d3b0600cb7c/pycountry-22.3.5.tar.gz"
    sha256 "b2163a246c585894d808f18783e19137cb70a0c18fb36748dc01fc6f109c1646"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/11/e4/a8e8056a59c39f8c9ddd11d3bc3e1a67493abe746df727e531f66ecede9e/pycryptodome-3.15.0.tar.gz"
    sha256 "9135dddad504592bcc18b0d2d95ce86c3a5ea87ec6447ef25cfedea12d6018b8"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/99/11/01fe7ebcb7545a1990c53c11f31230afe1388b0b34256e3fd20e49482245/websocket-client-1.4.1.tar.gz"
    sha256 "f9611eb65c8241a67fb373bef040b3cf8ad377a9f6546a12b620b6511e8ea9ef"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/streamlink.1"
  end

  test do
    system "#{bin}/streamlink", "https://vimeo.com/189776460", "360p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MP4 v2", shell_output("file video.mp4")
    output = shell_output("#{bin}/streamlink -l debug 'https://ok.ru/video/3388934659879'")
    assert_match "Available streams:", output
    refute_match "error", output
    refute_match "Could not find metadata", output
  end
end
