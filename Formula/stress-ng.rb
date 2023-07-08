class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.16.00.tar.gz"
  sha256 "f3d99281fe2f9695d627608a3aa610dfd6f3fa6eb1a3d7c457b09ff6defd0f78"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d351f22d2b5da9c363754fe164f5fb31bb9f8223e48157430bc2922a624a9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96c6a3cb467d4bb81abbc599c850765e5bd8af9867d0e0816e958f632225e469"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ec9ccbdfbe22d2dfb6628a206dcc75daf02738cee920725ea8f9a3ec02a2bee"
    sha256 cellar: :any_skip_relocation, ventura:        "b998ea9521db8491e72f9126477eb86e66e06db5817c7a1b6a7cd4b8cf19d1ad"
    sha256 cellar: :any_skip_relocation, monterey:       "b0b75bfcbd6e817866977167c37ae8f0e49d98c620fcda57114f31b23cacefec"
    sha256 cellar: :any_skip_relocation, big_sur:        "696960621259ecd4fc21bd0636893d01185f7c8871082d6193ba5ab41492f0a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9df5fa69efc3466853344071853df425e3a5b9436455f51100efc5942fb09f6"
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
