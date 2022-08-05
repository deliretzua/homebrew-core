class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "6b12e279935fc7a2f37caa558d507bb5746fd05e5afba23a66c8a8a3f661ddb9"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6523e6268a6f752f63380b21c426ea78fdb0dc2428fbc0e54623ea025be5c4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6523e6268a6f752f63380b21c426ea78fdb0dc2428fbc0e54623ea025be5c4d"
    sha256 cellar: :any_skip_relocation, monterey:       "8235b5c095f71446d188b436e196e51dced889cbb324d406cb216432073078a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8235b5c095f71446d188b436e196e51dced889cbb324d406cb216432073078a3"
    sha256 cellar: :any_skip_relocation, catalina:       "8235b5c095f71446d188b436e196e51dced889cbb324d406cb216432073078a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b281c204c6939384eb83a5899a85719bc1f22c138879570a129c43082f096289"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/railwayapp/cli/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    output = Utils.safe_popen_read(bin/"railway", "completion", "bash")
    (bash_completion/"railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "zsh")
    (zsh_completion/"_railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "fish")
    (fish_completion/"railway.fish").write output
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Account required to init project", output
  end
end
