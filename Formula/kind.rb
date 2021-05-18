class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.11.0.tar.gz"
  sha256 "c78bed3a39afd2e523b38256b7f16445d0ad4b8b25f18b5766005e095af772cd"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef444e0ee20b8bc341b430aa8d3eced29b5ecfeb16b8754449d7e3a67c9d8f1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "f0447bc4b8145224995dbcde38f218e6ad3eddf7cec43cc30103d9e89fa8f595"
    sha256 cellar: :any_skip_relocation, catalina:      "872579a3058f9d1e65261effc0b527b80a06fab5c6ea993645a136c19c282d7b"
    sha256 cellar: :any_skip_relocation, mojave:        "ef9d4fb28756c10b4702fd8721ca3c1286af8e2667ac67742b221d2b480eeebd"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", "-o", bin/"kind"
    prefix.install_metafiles

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "bash")
    (bash_completion/"kind").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "zsh")
    (zsh_completion/"_kind").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "fish")
    (fish_completion/"kind.fish").write output
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end
