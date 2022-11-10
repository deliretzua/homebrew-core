class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.1.3",
      revision: "1b72df6594134e7b7fc60f1801d418c51bbcc3d7"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bd176589d8afa4ee8b9443cf2ac4c53bb5357ecaaa11e16f41a7ae9ff10f695"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bd176589d8afa4ee8b9443cf2ac4c53bb5357ecaaa11e16f41a7ae9ff10f695"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bd176589d8afa4ee8b9443cf2ac4c53bb5357ecaaa11e16f41a7ae9ff10f695"
    sha256 cellar: :any_skip_relocation, monterey:       "eceb000a78b1653efee4d544347f27529ad910c4da2b68823ecd16025415edd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "eceb000a78b1653efee4d544347f27529ad910c4da2b68823ecd16025415edd9"
    sha256 cellar: :any_skip_relocation, catalina:       "eceb000a78b1653efee4d544347f27529ad910c4da2b68823ecd16025415edd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12799955bd8ae11e903b762284cfaf25090766b6de39fd39ba0cf12c201c267a"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    chdir "clients/go/cmd/zbctl" do
      project = "github.com/camunda/zeebe/clients/go/v8/cmd/zbctl/internal/commands"
      ldflags = %W[
        -w
        -X #{project}.Version=#{version}
        -X #{project}.Commit=#{commit}
      ]
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags: ldflags)

      generate_completions_from_executable(bin/"zbctl", "completion")
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end
