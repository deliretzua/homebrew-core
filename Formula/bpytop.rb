class Bpytop < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://github.com/aristocratos/bpytop/archive/v1.0.68.tar.gz"
  sha256 "3a936f8899efb66246e82bbcab33249bf94aabcefbe410e56f045a1ce3c9949f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1bd3b8d238bcf9aa980f88e4087b3ca0577fcfb96fa4582babeb9bc91fe0bfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1056028c0249a04cdb1696c1f265d175b5678076ae2cd5b27145f4b875334bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f268476fd2df933516f1de95768823eced9da2cd13c59be425accf26b5b938c"
    sha256 cellar: :any_skip_relocation, monterey:       "ba6ba12c03d0a7ff3f01e9185f0139009ea71035fabc0da0fdf990a974cdab4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "98fe82eb4ede78b2ea8dce83bce7648ae338b6e8478eb5fb2c9138db8ccea1d4"
    sha256 cellar: :any_skip_relocation, catalina:       "85bc433985ef601004bbb0393e2b4a092b840f1abf48e42e5eb12a59893e8796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4a390cf927eaab56b3432ecfe161e07066e99ce2fd964b4e6980013f4c78d32"
  end

  depends_on "python@3.11"

  on_macos do
    depends_on "osx-cpu-temp"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/de/eb/1c01a34c86ee3b058c556e407ce5b07cb7d186ebe47b3e69d6f152ca5cc5/psutil-5.9.3.tar.gz"
    sha256 "7ccfcdfea4fc4b0a02ca2c31de7fcd186beb9cff8207800e14ab66f79c773af6"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "themes"

    # Replace shebang with virtualenv python
    rw_info = python_shebang_rewrite_info("#{libexec}/bin/python")
    rewrite_shebang rw_info, bin/"bpytop"
  end

  test do
    config = (testpath/".config/bpytop")
    mkdir config/"themes"
    (config/"bpytop.conf").write <<~EOS
      #? Config file for bpytop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/bpytop")
    r.winsize = [80, 130]
    sleep 5
    w.write "\cC"

    log = (config/"error.log").read
    assert_match "bpytop version #{version} started with pid #{pid}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
