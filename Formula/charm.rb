class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/v2.5.2.tar.gz"
  sha256 "3dd52c9a463bc09bedb3a07eb0977711aec77611b9c0d7f40cd366a66aa2ca03"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "c3c809d7c9488ae876f1549f825284dac9e500070ee62d9b351ff28c84e1620c"
    sha256 cellar: :any_skip_relocation, catalina:    "b2a4c9b953f6a54c51a171d819cfddc0655caf857ec72c3ec5136493f9296b24"
    sha256 cellar: :any_skip_relocation, mojave:      "58e3a054f6b6ff73184e1f2909ee58117bd023bc28e448af2d6fe2e82b192735"
    sha256 cellar: :any_skip_relocation, high_sierra: "389d0723e4bcc34bc7747e66f7f721a36cf1ab63623ec23982d68ca2623e3f29"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/charm"
  end

  test do
    assert_match "show-plan           - show plan details", shell_output("#{bin}/charm 2>&1")

    assert_match "ERROR missing plan url", shell_output("#{bin}/charm show-plan 2>&1", 2)
  end
end
