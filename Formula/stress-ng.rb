class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.10.tar.gz"
  sha256 "fcd86e1b8db5b2c22182cefbf4b3131a8599bff5bdd85edf776ec15c2d80e8f1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b4035286661f27afd82b24c45a1c82bd999cfb44afc91ec84f45f29add10edd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7d08ab8a9a83039311a29316ebce35fb7074e396d875aa9b40ce6f3272813a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "264cf56147d3f898ca16d4c584e279cbd80213fb622f9e96a911fe092d04f386"
    sha256 cellar: :any_skip_relocation, ventura:        "89e9603b2df313f49f5e616941f6461a89ca93ad3b1bd5b45822bb8abc16d9e2"
    sha256 cellar: :any_skip_relocation, monterey:       "e8c9ef28cace8ec8395904ff76803ca001bc12712e88c694aac08d703fd98e5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "719fdd53910b2dc084ea32b43ef0d5c8e0bb1acef4c28ea20636d86cee157a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033b7150ad3fc1ab6413eb0791cfdf6590f62e6f8469d72d832bf229e9c1b38b"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
