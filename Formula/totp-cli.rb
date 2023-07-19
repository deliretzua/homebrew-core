class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.5.0.tar.gz"
  sha256 "6d41bf991d28124f1a1f424e8ab9df0f22bfe8699257eb39d1bc2d293c52aa47"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18c3e8174e034e719dbb7e07bcd48b9bcd44738e38b0c68f874d50026983f9c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18c3e8174e034e719dbb7e07bcd48b9bcd44738e38b0c68f874d50026983f9c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18c3e8174e034e719dbb7e07bcd48b9bcd44738e38b0c68f874d50026983f9c5"
    sha256 cellar: :any_skip_relocation, ventura:        "ebfd06e01b256ab71af1a72a0badf5722551e2b468915240ae7045c40fe0db90"
    sha256 cellar: :any_skip_relocation, monterey:       "ebfd06e01b256ab71af1a72a0badf5722551e2b468915240ae7045c40fe0db90"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebfd06e01b256ab71af1a72a0badf5722551e2b468915240ae7045c40fe0db90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40a8fd4dda1a70622e419d9b1c6090c916cc424ba92f141e2197a9b1232dbeb9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "autocomplete/bash_autocomplete" => "totp-cli"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end
