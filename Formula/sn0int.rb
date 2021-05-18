class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.21.1.tar.gz"
  sha256 "4546661f2b3daf93d61f9685502051b4a36a463fb3582888b48236005f39bc5c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7d001c71593c23fc12bc613badb05fe89d0cd2987128b77cab47e2383c522baa"
    sha256 cellar: :any, big_sur:       "6474556cd34b9f844287a0bb6a9dcb07616341b28aa7f938fd4e0605314a9a88"
    sha256 cellar: :any, catalina:      "d21489cd43a9234923ce33344b29ac750a9344d6b65d0ceb4c17e63b8114b6cd"
    sha256 cellar: :any, mojave:        "a9779b78ec3a79798acc7869a7f219068ffef4b57b273dbc7e60fd9f02f2049c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libsodium"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "cargo", "install", *std_cargo_args

    system "#{bin}/sn0int completions bash > sn0int.bash"
    system "#{bin}/sn0int completions fish > sn0int.fish"
    system "#{bin}/sn0int completions zsh > _sn0int"

    bash_completion.install "sn0int.bash"
    fish_completion.install "sn0int.fish"
    zsh_completion.install "_sn0int"

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/1/sn0int.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system "#{bin}/sn0int", "run", "-vvxf", testpath/"true.lua"
  end
end
