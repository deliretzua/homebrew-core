class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v4.2.5110.tar.gz"
  sha256 "ece33932747ddd9a4295bd0c887193a2c178ef870c503780336819d2bf575b2f"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a318891757cdafc3ea9b6e2a11d4c0e3e1df9af892b5fa2c60373014a5b2d9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4ac55da1069594a5c6a5b3f122fdc89fed487e25c5fde376a1d5ea5369ef8e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "897fabd2fb771cb3d341fe2737bb5ef245b03a39684837816e206d1d921b0cfc"
    sha256 cellar: :any_skip_relocation, ventura:        "3284acc827a2652f8590ea8f428813da0295d799f601b704b39fbeeea28e1d10"
    sha256 cellar: :any_skip_relocation, monterey:       "3af35b2de5d09f88e308be36861daada90c034fa2f3a8b74d300c003c526ef3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "351658fb02b336086367060ebf85c6fc606188adc0db4c0db0fdc2c99ff4763a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0fc3ed74bb7e9e64a1ee7f008c1180362db0a3c9f9fe3a5dcf7992c9d97b4e5"
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
