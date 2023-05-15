class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v1.2.4.tar.gz"
  sha256 "1d7c355b3060a35a8679e446cbe504423e09b55296c044a51a27a23c9298329b"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3784b020ef7b429fe916ee63b7ffa55ce395a7e979d2c83e55125aac9ed64c59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3784b020ef7b429fe916ee63b7ffa55ce395a7e979d2c83e55125aac9ed64c59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3784b020ef7b429fe916ee63b7ffa55ce395a7e979d2c83e55125aac9ed64c59"
    sha256 cellar: :any_skip_relocation, ventura:        "8277328bfcc8be6974611ae0b483737f31c92f910247c55401017b670c1148ba"
    sha256 cellar: :any_skip_relocation, monterey:       "8277328bfcc8be6974611ae0b483737f31c92f910247c55401017b670c1148ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "8277328bfcc8be6974611ae0b483737f31c92f910247c55401017b670c1148ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84878b5b22276b899c4edf7a3b62f85a4d974f0f06e2520492e12074e063b6bf"
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build", *std_go_args(output: bin/"lean", ldflags: "-s -w -X main.pkgType=#{build_from}"), "./lean"

    bin.install_symlink "lean" => "tds"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    output = shell_output("#{bin}/lean login --region us-w1 --token foobar 2>&1", 1)
    assert_match "[ERROR] User doesn't sign in.", output
  end
end
