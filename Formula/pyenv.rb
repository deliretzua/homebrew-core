class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "7ac658f98ed64bc9c5ef56614594dc052357853ec5703c8df91e9beff0d5177c"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b88344e260fdf2f955d3dd284cf32e43045d49b917e2f63578b52dea0d9d6f53"
    sha256 cellar: :any,                 arm64_monterey: "5c7a59b5dbc74e2604b2f52d815628aa71e4e8fc650d1593713d153cfce02106"
    sha256 cellar: :any,                 arm64_big_sur:  "63dc34cd723cbad449646b26e0d3c627d3d2c7068677eb608e95a2f2345d37e3"
    sha256 cellar: :any,                 ventura:        "ad4ff2d4ceeeb49372ac1f3c4eb3816074b045e71f6bed5ba1712ad9bfc72ba1"
    sha256 cellar: :any,                 monterey:       "972747efa1e5e635c5332e97d5c73a986bfe5e54094f742b106c18bf1a486a45"
    sha256 cellar: :any,                 big_sur:        "c6ba5d5095fe36740811c003ed60fe00eb65fa1bab27fdf636693ad8702129d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f68a683a3d151b1b779735872debe37e3cdc51743d937c8d2e22dbf063e6c80"
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-rehash", "$(command -v pyenv)", opt_bin/"pyenv"
    inreplace "pyenv.d/rehash/source.bash", "$(command -v pyenv)", opt_bin/"pyenv"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    share.install prefix/"man"

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    # Create a fake python version and executable.
    pyenv_root = Pathname(shell_output("pyenv root").strip)
    python_bin = pyenv_root/"versions/1.2.3/bin"
    foo_script = python_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                            "&& eval \"$(#{bin}/pyenv init -)\" " \
                            "&& pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system "pyenv", "rehash"
    refute_match "Cellar", (pyenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                                       "&& eval \"$(#{bin}/pyenv init -)\" " \
                                       "&& PYENV_VERSION='1.2.3' foo").chomp
  end
end
