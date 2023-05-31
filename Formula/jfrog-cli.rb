class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.38.4.tar.gz"
  sha256 "d31b5eaa8507a3e5e63fedb2c09f3d24d4123e7dcfe736dc2ac95dcfc8c3af54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1841d774931097d88d931545a6799909b55457bcdd151258bffa4c86b7220636"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1841d774931097d88d931545a6799909b55457bcdd151258bffa4c86b7220636"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1841d774931097d88d931545a6799909b55457bcdd151258bffa4c86b7220636"
    sha256 cellar: :any_skip_relocation, ventura:        "7aac72168481d736051fab2278ce7fe659e57a4a7e4c369f97f9f8849818ec5c"
    sha256 cellar: :any_skip_relocation, monterey:       "7aac72168481d736051fab2278ce7fe659e57a4a7e4c369f97f9f8849818ec5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7aac72168481d736051fab2278ce7fe659e57a4a7e4c369f97f9f8849818ec5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c71ad4400a71bbd21739460039adda9fb1143c69382fab6bfe102a6a9226c96"
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
