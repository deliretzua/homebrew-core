class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v4.3.3200.tar.gz"
  sha256 "3b03acf2339e32d83704db190c2cb34fecb9a941ea8b4ab4ac32ba8a33d75f46"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7ea487c7a98eb8b4b963b6aa69129cfb46a6fbf8d8589ad71d8a836dafc35f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07f096c7cb9e9bbcce0f01106f272e00f4725d0ca0215a9da8e76e51599a3993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a134be74ab21f5c8ec00bdbee7e560d6e42b95482e3cbbafddad9e7ffc598dc6"
    sha256 cellar: :any_skip_relocation, ventura:        "1b5bffa7b74d7fed0e9d53a7cf6df64925178a3e5de48ffcd6b3f00fae0e9777"
    sha256 cellar: :any_skip_relocation, monterey:       "f39d7eef1f02da0dd68b5d87a4c5df2c4ded2fc8fe5eda19e78f18ea9ee8edab"
    sha256 cellar: :any_skip_relocation, big_sur:        "13686554dc91a8b72511a40b32ac4ee9898f85ce6586ecf70772338eb44b06a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6770ec72afcba499934677434d8d08cb69da2e8858bc45030451a0f74dd95a62"
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
