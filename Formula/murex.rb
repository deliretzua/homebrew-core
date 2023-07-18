class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v4.4.8000.tar.gz"
  sha256 "8910c80a646caed3d0cbf0df25b58d754638350745d771912e7237e7136617f5"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a45a45d1771d76bbdd65146bcc4034cae059bc9bf5ce7079eff43b1fc084db14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "590d36991763e97cef2f1b27f119a4779fe80ec148e5a68716be570ca6ee2e4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a937ecbc01cf2000d95d92974bbb20c72a636fc30a1c4467329b008a49e91f7"
    sha256 cellar: :any_skip_relocation, ventura:        "b97898113f83b71fd7c0b3aff20829988ba94ef270b89502771eff7a01a3a4c0"
    sha256 cellar: :any_skip_relocation, monterey:       "ddcc236e717bee6e8b0dd9f69f82c4f7b2c49f6f695b6734d15339fe3c4e4593"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f1faca3798ad1cd32a364646e1c9abe2e8317fb3dbc68ce727437e0ed3fce5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98c6ce3326f6dde6820b819ae29546a6a586f5ff960cf98abb6335bb582ac8b0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
