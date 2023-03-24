class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v1.2.3.tar.gz"
  sha256 "9ad8d6d8f37b2b40c8540f72b3e9a63ee8ff3ff3472d296694c8b8b744503eb5"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "088d6498605ace550b06a84143ae5761ea98234c457db399bc15d0d565038ca7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "088d6498605ace550b06a84143ae5761ea98234c457db399bc15d0d565038ca7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "088d6498605ace550b06a84143ae5761ea98234c457db399bc15d0d565038ca7"
    sha256 cellar: :any_skip_relocation, ventura:        "99ce7866f6dd9c8ccff6d1499b4b10cea8337b73d60d8a6156f852eda083c890"
    sha256 cellar: :any_skip_relocation, monterey:       "99ce7866f6dd9c8ccff6d1499b4b10cea8337b73d60d8a6156f852eda083c890"
    sha256 cellar: :any_skip_relocation, big_sur:        "99ce7866f6dd9c8ccff6d1499b4b10cea8337b73d60d8a6156f852eda083c890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9371d6567332bfdc80d69c97e94cb37a6301f21706bacd05bdc34db295529b8"
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
