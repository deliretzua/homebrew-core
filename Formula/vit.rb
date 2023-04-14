class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://files.pythonhosted.org/packages/44/1c/e92432357d5dd26ad086e4a05ff066c0539e754fbe3dfdd78e0cb206964b/vit-2.3.0.tar.gz"
  sha256 "f3efd871c607f201251a5d1e0082e5e31e9161dde0df0c6d8b5a3447c76c87c6"
  license "MIT"
  head "https://github.com/vit-project/vit.git", branch: "2.x"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a9ec60c1bea0b80ec4a455e3947af84a84ac93eec8b76150904bad79685dd8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92a82feed66d18761246eed767e5bcefe18cbe17c36f4104e245e9a8fc6ccc9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9a265b17cc76cb95b5852d458bc5996af619f85676d8b86ae69888e93d78f41"
    sha256 cellar: :any_skip_relocation, ventura:        "98d3fa88a855c8aaa0d6c896b0deb0d72bbde2094395f05018413d8d7acae90c"
    sha256 cellar: :any_skip_relocation, monterey:       "7593aad3669004423effee2c0a1e27ea2e64e1763846f70054df85bf4d7b763e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f0526731e932d972914287016dac6953abba079b17da0e8dc4900a75ec3a848"
    sha256 cellar: :any_skip_relocation, catalina:       "fa0b151ea6e6ff4c747d77792843a6e5564318aae35afbd5a6fbbebd83920901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b268d1e61ed6854790d059dcebcd02ee54fab57bdccbedd113afef01ba71bd0"
  end

  depends_on "python@3.11"
  depends_on "task"

  resource "tasklib" do
    url "https://files.pythonhosted.org/packages/3e/50/3e876f39e31bad8783fd3fe117577cbf1dde836e161f8446631bde71aeb4/tasklib-2.5.1.tar.gz"
    sha256 "5ccd731b52636dd10457a8b8d858cb0d026ffaab1e3e751baf791bf803e37d7b"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".vit").mkpath
    touch testpath/".vit/config.ini"
    touch testpath/".taskrc"

    require "pty"
    PTY.spawn(bin/"vit") do |_stdout, _stdin, pid|
      sleep 3
      Process.kill "TERM", pid
    end
    assert_predicate testpath/".task", :exist?
  end
end
