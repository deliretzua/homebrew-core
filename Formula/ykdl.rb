class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/SeaHOH/ykdl"
  url "https://files.pythonhosted.org/packages/f2/27/f4e7616a139c84a04edb7778db2b3cfb77348ab73020ff232b6551fa8bdd/ykdl-1.8.2.tar.gz"
  sha256 "c689b8e4bf303d1582e40d5039539a1a754f7cf897bce73ec57c7e874e354b19"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "640bc5ee77d8ea688159fa49036e16598af7daa688b4c4273ad8af4c0073784b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3925aefb6ab1b1aaaed0017b58389fda5d41caa3576b5abd6d3f90c7b6ad032e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "525b278ce098cc7db35e67ba9b646b4fab11b336165e8154b8182b74fc080a5e"
    sha256 cellar: :any_skip_relocation, ventura:        "c4240dcdf6441c43f6843b157eea6234f91df256c778d70a25bf2529d4c0f22a"
    sha256 cellar: :any_skip_relocation, monterey:       "a41ee9274c1ce3ac32efaf68e39e1dbd23c6b1200edba87b29ac0348c7934e93"
    sha256 cellar: :any_skip_relocation, big_sur:        "679aecf0ff6c8e8ad66673e12430c00c48ee8c36ca975cefb72cc576fb4cfacf"
    sha256 cellar: :any_skip_relocation, catalina:       "a3cb7962ec480fc511d09b8c4ff730b472ce275e5502de686667a2d34da378ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85fa3fe5e540fc474f73817e7936bd01544b5b36786701231336ef1dd99e6ad"
  end

  depends_on "python@3.11"

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/27/23/97cd1cb5792ece594ec5cf16cc4921f91838c689c82c8078ee442751f8dc/iso8601-2.0.0.tar.gz"
    sha256 "739960d37c74c77bd9bd546a76562ccb581fe3d4820ff5c3141eb49c839fda8f"
  end

  resource "jsengine" do
    url "https://files.pythonhosted.org/packages/bc/0a/1321515de90de02f9c98ac12dfa9763ae93d658ed662261758dc5e902986/jsengine-1.0.7.post1.tar.gz"
    sha256 "2d0d0dcb46d5cb621f21ea1686bdc26a7dc4775607fc85818dd524ba95e0a0fd"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/05/97/e1279c9f025838df264c6643b132a6f3778f8215281fc501644547a821a9/m3u8-3.5.0.tar.gz"
    sha256 "b2eeaa768de574c9d05aad135b1073992927ce0a20b968ebb13f3a183fa92488"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    system bin/"ykdl", "--info", "https://v.youku.com/v_show/id_XNTAwNjY3MjU3Mg==.html"
    assert_match version.to_s, shell_output("#{bin}/ykdl -h")
  end
end
