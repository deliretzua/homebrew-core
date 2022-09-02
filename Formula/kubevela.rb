class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.5.4",
      revision: "17872f97050bb0d039b6f7f0f7245fe7f714fe9f"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c5c33386fa65d3ebf06a45911b17bc2f8328f9ce01b5e39524b6ed81dc24dd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c5c33386fa65d3ebf06a45911b17bc2f8328f9ce01b5e39524b6ed81dc24dd0"
    sha256 cellar: :any_skip_relocation, monterey:       "3555647a179e45b41945ac260406e690acbd11717cfd3d6ebd85cb484daf6ab2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3555647a179e45b41945ac260406e690acbd11717cfd3d6ebd85cb484daf6ab2"
    sha256 cellar: :any_skip_relocation, catalina:       "3555647a179e45b41945ac260406e690acbd11717cfd3d6ebd85cb484daf6ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "608af7855b84bc78dd0725ff11bf71b8a90f96166589974c57003c60ab33ff4f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/oam-dev/kubevela/version.VelaVersion=#{version}
      -X github.com/oam-dev/kubevela/version.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin/"vela", ldflags: ldflags), "./references/cmd/cli"
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "error: no configuration has been provided", status_output

    (testpath/"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    ENV["KUBECONFIG"] = testpath/"kube-config"
    version_output = shell_output("#{bin}/vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end
