class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.4.4",
      revision: "36b6c3e7b524c81eb823a2234ca26f5d93621ed9"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20d960f4169391af726c920133ee28c8d085e6f36c03d0b884e4e84ba1bf83b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20d960f4169391af726c920133ee28c8d085e6f36c03d0b884e4e84ba1bf83b0"
    sha256 cellar: :any_skip_relocation, monterey:       "0bda0a371d25596ead04657bb7cad28d9c57faecbd958ff366a582ed945fee96"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bda0a371d25596ead04657bb7cad28d9c57faecbd958ff366a582ed945fee96"
    sha256 cellar: :any_skip_relocation, catalina:       "0bda0a371d25596ead04657bb7cad28d9c57faecbd958ff366a582ed945fee96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e3a7347215d2a0dec41d52501578dc241876c92f8dd553a624976a10cb0e669"
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
