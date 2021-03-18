class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.24.0/chapel-1.24.0.tar.gz"
  sha256 "77c6087f3e0837268470915f2ad260d49cf7ac4adf16f5b44862ae624c1be801"
  license "Apache-2.0"

  bottle do
    sha256 big_sur:     "5a3c5dc65fc572a84d9e4a8a5bcd7cac9c072822dbf674ebe32d7b740aeda63b"
    sha256 catalina:    "5aa5b6a7e03ed702530959c1983e8989be5f1ba4494af6d9da044e38ef62bfcb"
    sha256 mojave:      "123c5824b82621b4984e1afbf4f01f5c20af8cbc03e7b1266af396f8eaa80f79"
    sha256 high_sierra: "101b6a940e07d3e86ec809b3f7737950e0ef12c61daf43ef92c00e95047333c5"
  end

  depends_on "python@3.9"

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    # This is for mason
    ENV["CHPL_REGEXP"] = "re2"

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "make"
      system "make", "chpldoc"
      system "make", "mason"
      system "make", "cleanall"
    end

    prefix.install_metafiles

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    bin.install Dir[libexec/"bin/darwin-x86_64/*"]
    bin.env_script_all_files libexec/"bin/darwin-x86_64/", CHPL_HOME: libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    ENV["CHPL_HOME"] = libexec
    cd libexec do
      system "util/test/checkChplInstall"
    end
  end
end
