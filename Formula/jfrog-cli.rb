class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "031521c6667143d6f33cf26efcd7ee82dd0adf38534c7b5cb3d893a08220803f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb30257026b57af76befef850bc6631f4f93e4188734a035eafae6417d2824df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb30257026b57af76befef850bc6631f4f93e4188734a035eafae6417d2824df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb30257026b57af76befef850bc6631f4f93e4188734a035eafae6417d2824df"
    sha256 cellar: :any_skip_relocation, ventura:        "b64a7b56134dae6a95771b72000039bc71f301f6b725cdf64283f1286be1301f"
    sha256 cellar: :any_skip_relocation, monterey:       "b64a7b56134dae6a95771b72000039bc71f301f6b725cdf64283f1286be1301f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b64a7b56134dae6a95771b72000039bc71f301f6b725cdf64283f1286be1301f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59a549aaa03e75d217ca0130fc396debf6d1c9bba8aade6dcabf715cb4bcb2c3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
