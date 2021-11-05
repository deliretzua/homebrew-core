class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/d5/41/cafdf42a67ff794d912960952fec7c481b2470ee29f1c671df8c19bd84a9/fonttools-4.28.0.zip"
  sha256 "a5a09dacac7dd8037957f97d0377f862b1ff862ba8d4d3f6182bc23a4b549c7a"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abb1d4cd25315a22866b365f0437d281cd157a16a79d0407eded33606bcaee56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abb1d4cd25315a22866b365f0437d281cd157a16a79d0407eded33606bcaee56"
    sha256 cellar: :any_skip_relocation, monterey:       "4fece6a6554fa5a8e899c1fe23d867392385864e73a7606acf124284d6670917"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fece6a6554fa5a8e899c1fe23d867392385864e73a7606acf124284d6670917"
    sha256 cellar: :any_skip_relocation, catalina:       "4fece6a6554fa5a8e899c1fe23d867392385864e73a7606acf124284d6670917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc5ef9d849626507f99a420d8a1d79b51c9dca5010eb39c5350906c5a07e8cd6"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
