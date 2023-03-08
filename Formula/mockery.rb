class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.21.3.tar.gz"
  sha256 "875061a9b9661bc81e3a5bfe45e22211efa2e000f08639e6d74314ac4ba1cd78"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1acd961c3eb66c7f0f7a7e16d57fa048b7284d5c297da7cfccd9fa7d803b129b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8236357911a1669e0fe1937a90eed52e974ac262178bc9e77f4658e347395eb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80b3b1628cb927297798523411726c55c58763dc20db96a2525ab037b00500b7"
    sha256 cellar: :any_skip_relocation, ventura:        "8443283190b0dc52ae5f6915c6d6f9dd0b065e9e22af2a416abcf7753b16cef6"
    sha256 cellar: :any_skip_relocation, monterey:       "555f837276d84d93d1d00cac30f8f759442b875209933d1b7f48f66be08c2a6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "543303c2fd20ebf18ec6d4d3c35a847d5ecfe06744648525ab7ff236e2894206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f488884c9544cfff61959c92627b65c8bbe19630cc8e8cde8d796371a763be63"
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
