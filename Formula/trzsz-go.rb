class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "4acf9e7f10b49a7f6a9d56f441bcb3f1029a19207682db37b0cbd4adcc283d43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51750f222071c15a3cac1fb2cf91cffa47aef9ed362774ad1333a0383f7cf1d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51750f222071c15a3cac1fb2cf91cffa47aef9ed362774ad1333a0383f7cf1d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51750f222071c15a3cac1fb2cf91cffa47aef9ed362774ad1333a0383f7cf1d3"
    sha256 cellar: :any_skip_relocation, ventura:        "3a3acc0054598ecf3c8a60be5d5e8204d73a10ec3c2f7746ec4227f91858975d"
    sha256 cellar: :any_skip_relocation, monterey:       "3a3acc0054598ecf3c8a60be5d5e8204d73a10ec3c2f7746ec4227f91858975d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a3acc0054598ecf3c8a60be5d5e8204d73a10ec3c2f7746ec4227f91858975d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d7d72d12f30999740a570e19d9e4882786e6fc54d71b0fcdf70ec887612348"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trz"), "./cmd/trz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tsz"), "./cmd/tsz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trzsz"), "./cmd/trzsz"
  end

  test do
    assert_match "trzsz go #{version}", shell_output("#{bin}/trzsz --version")
    assert_match "trz (trzsz) go #{version}", shell_output("#{bin}/trz --version 2>&1")
    assert_match "tsz (trzsz) go #{version}", shell_output("#{bin}/tsz --version 2>&1")

    assert_match "spawn pty failed: &exec.Error", shell_output("#{bin}/trzsz cmd_not_exists 2>&1", 255)
    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1", 254)
    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1", 255)
  end
end
