class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.7",
      revision: "9b4e705e86c3334ceb42bffe3b7fd97d67e230ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1adb362df02fd45f248aa4337933754a13413d3323e2c2a915ee0c29cc2ce510"
    sha256 cellar: :any_skip_relocation, big_sur:       "c1859eb14cc8aec6867dce0f976d0819d52cf903e90a9d518564afa67fb59bd8"
    sha256 cellar: :any_skip_relocation, catalina:      "c4b723a950b0d7fa9a72ca40d6a0db42d7e259e223092d673b78f039bc4137b9"
    sha256 cellar: :any_skip_relocation, mojave:        "f256f68a2b41e69d0cb88afbdbfb69642d64c7b85698523a6a7677ca65ea1f3c"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")
    assert_match "authentication failed",
                 shell_output("#{bin}/argocd-autopilot repo create -o foo -n bar -t dummy 2>&1", 1)
  end
end
