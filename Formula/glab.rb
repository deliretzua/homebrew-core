class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.29.0/cli-v1.29.0.tar.gz"
  sha256 "5ea8c805f3555352c2cc55cf174f1430dffe3a19570ce25b1889a3903fd0dd0f"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d5011e959584f635f59a28afbbf3f2a629350381a1405e94e55cdfe29f02898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5011e959584f635f59a28afbbf3f2a629350381a1405e94e55cdfe29f02898"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d5011e959584f635f59a28afbbf3f2a629350381a1405e94e55cdfe29f02898"
    sha256 cellar: :any_skip_relocation, ventura:        "1756e54d378eafbce806d0763481024663d216190d175eb717d33ec1fed7dd50"
    sha256 cellar: :any_skip_relocation, monterey:       "1756e54d378eafbce806d0763481024663d216190d175eb717d33ec1fed7dd50"
    sha256 cellar: :any_skip_relocation, big_sur:        "1756e54d378eafbce806d0763481024663d216190d175eb717d33ec1fed7dd50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fccc8f32daab746772b1e4494ea83d5e9345c3cefcf0f47bd1126e00058daffd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
