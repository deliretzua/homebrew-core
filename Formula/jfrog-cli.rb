class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.37.2.tar.gz"
  sha256 "07f97fadcfbcdb8bb9549719017cbfa7dc6f6311bf6968d1bf79e4602dc95fa4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca04379a5faaa64190916d6e6cbec35c050e077d2e85a22dbaff23e5e420422b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca04379a5faaa64190916d6e6cbec35c050e077d2e85a22dbaff23e5e420422b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca04379a5faaa64190916d6e6cbec35c050e077d2e85a22dbaff23e5e420422b"
    sha256 cellar: :any_skip_relocation, ventura:        "f429ec54fe14b677d8998510cc18770535da4d11a9082bf3aa7f163746fe4862"
    sha256 cellar: :any_skip_relocation, monterey:       "f429ec54fe14b677d8998510cc18770535da4d11a9082bf3aa7f163746fe4862"
    sha256 cellar: :any_skip_relocation, big_sur:        "f429ec54fe14b677d8998510cc18770535da4d11a9082bf3aa7f163746fe4862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8ddbde0b393bd7fc550f72e2b1520da1e9b9ded2f1f0105aa047f8100acd385"
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
