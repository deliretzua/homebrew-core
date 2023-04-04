class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/08/3f/9fd254a40155c8f51b52b045f5df16a794d21d4c3dfeb8c5d379671e72f1/pympress-1.8.2.tar.gz"
  sha256 "d9587112ab08b1c97d8f9baccde2f666b4b6291bd22fcb376d27574301b2c179"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ecd1b41760fe8dd7a96168e48229382a9b5d06aac7bb8c44f11250b4a6dbb0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "483ba52b484159ed0d3ff9e8bda47bc1188920a88142c03df996f46ac771dd01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14c1f8fb383827fa337df9cd5143b81f533d74460e62fca97b4dda8107490157"
    sha256 cellar: :any_skip_relocation, ventura:        "420751588146ab08f278c27cc55f8725ca6d6c83a50daa0872b3eb2bbd9a8cd5"
    sha256 cellar: :any_skip_relocation, monterey:       "7998d879b8adb53e8cfecd60e9e9718c65d78f2a70fdf465bd50418f033fdf7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1790050922cad16eb68f63e73f1b3faf99821283fb44ec088a555072c3fcca68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2e384c4fbe7ecbe81ddb8e1aa58c317a4db0160684502b858997afcdd6c97e6"
  end

  depends_on "gobject-introspection"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gst-plugins-ugly"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.11"

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/pympress"
  end

  test do
    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    ENV["PYMPRESS_HEADLESS_TEST"]="1" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"pympress", "--quit"

    # Check everything ran fine at least until reporting the version string in the log file
    # which means all dependencies got loaded OK. Do not check actual version numbers as it breaks --HEAD tests.
    log = if OS.linux?
      Pathname.new(ENV["XDG_CACHE_HOME"] || (testpath/".cache"))/"pympress.log"
    else
      testpath/"Library/Logs/pympress.log"
    end
    assert_predicate log, :exist?
    assert_match "INFO:pympress.app:Pympress:", log.read
  end
end
