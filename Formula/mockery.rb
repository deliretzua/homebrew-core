class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.30.16.tar.gz"
  sha256 "b92d44f37e64115c970c9d6717dd9e9c91830c1689dd0a945ada245854c415ed"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dddd00fa12c561b63853d0014a31bb2300f94a88b438dff06fee082b81e3ae50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2725bbda0070845505a6e28e32567977cad4ae2e42694889d08198966c9cbf4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3f755de83e3b9347a61d3ceb389de6497ff6a1e2f112da3f1f1cb8f30e776c7"
    sha256 cellar: :any_skip_relocation, ventura:        "90ad5e016be1f98e537cd70a97b3445d8a58e823b3d0a0fc4718c9a9f450ec81"
    sha256 cellar: :any_skip_relocation, monterey:       "06fb56857ced7920a5924bd637ae3193931006e3aabc6442726656fa7128f6c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "965a09343e30ed0b7a2a20ba2f23d0841af3e983f01d09e54137c5be58022a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ae2dabe35f2ee11a36528e715b6c5a934e844e9c79d60b021ce900de26b5b51"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
