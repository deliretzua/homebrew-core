class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.39.0.tar.gz"
  sha256 "86eb8079b88896dfbfb8e165adba75a7de3477b21f20ee8282efff2f0ab1356b"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a2b439a540196293beee0a267eadaf59f0d8f96a335bd65268ded1e56dcf2f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a796edf89e3d797011b563c0baa0a2543b075c33f443013c8176dc4ca589ad9"
    sha256 cellar: :any_skip_relocation, monterey:       "5780b42516de2ed445ec5e08b92ba93f4217f3365f76e6f06ee7f164c8624823"
    sha256 cellar: :any_skip_relocation, big_sur:        "80065a2146aa4f06624075bee0b259a1509acc3b928fdbfcf3de092e4e12eeb8"
    sha256 cellar: :any_skip_relocation, catalina:       "6afb1b8223142a72b143c9012c61d20f7f8b7992cb010cb512c07592b1f535b8"
    sha256 cellar: :any_skip_relocation, mojave:         "b710a1108d8e391750350918b60cae0e1f41c84fcf90c7c3720af180451a4e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35defe65118ff689983daff51b6e6953a814da30335e614077bcbabb09864db6"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end
