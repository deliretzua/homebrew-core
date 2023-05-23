class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "2100feea24dbbd3ad8d77e7d61a04be4240af7536bd1cfb176a50c3ae3f0212d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef25660fcc4773f507b6701d66d96ce4de64222a6258afe66853174293ca00b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef25660fcc4773f507b6701d66d96ce4de64222a6258afe66853174293ca00b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef25660fcc4773f507b6701d66d96ce4de64222a6258afe66853174293ca00b3"
    sha256 cellar: :any_skip_relocation, ventura:        "a77cadb14f72406d3b4ea5571da00e1091352775b023fa780dad5892746b3e83"
    sha256 cellar: :any_skip_relocation, monterey:       "a77cadb14f72406d3b4ea5571da00e1091352775b023fa780dad5892746b3e83"
    sha256 cellar: :any_skip_relocation, big_sur:        "a77cadb14f72406d3b4ea5571da00e1091352775b023fa780dad5892746b3e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec5ee9e1819951e60ed668556ea372252ad9368b89fbd7d17e5f351c865e2aa4"
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
