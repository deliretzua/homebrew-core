class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.41.0.tar.gz"
  sha256 "fd8fc0a4c43d18e0e0d1d0b12d3941d9ea271b4f30d797bb2f88297957112f47"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4caa7956bd480488654891b8cb080eac969adf21f47508da212c1e90dcfafd13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4caa7956bd480488654891b8cb080eac969adf21f47508da212c1e90dcfafd13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4caa7956bd480488654891b8cb080eac969adf21f47508da212c1e90dcfafd13"
    sha256 cellar: :any_skip_relocation, ventura:        "a44b79525f2ef88a113b42b7fa695513e37bba34edbbeb496369559c171b18d0"
    sha256 cellar: :any_skip_relocation, monterey:       "a44b79525f2ef88a113b42b7fa695513e37bba34edbbeb496369559c171b18d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a44b79525f2ef88a113b42b7fa695513e37bba34edbbeb496369559c171b18d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d534213e8348b7ff686c2fe4077b5dfa3b4b451ac35e5a135c241e42a17e0b31"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
