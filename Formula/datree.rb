class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.54.tar.gz"
  sha256 "4b03ec23262247b96ff01e0f8d5933a2a926a0f388efce7cbd53167e8ee73b3a"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abad00c930ecdf06973c8ab56ef0fbeb758d7a8c26414ecb7d2d3cbcdaf4536a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c9f5cf00131c1bff4bff6e4e913a85a68edf5bacd21abfadc0c3dff8d25d436"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6634308da862ce75355ac1fec1c0b4a9133ba6bdb416c41ad9f2059fac599e3c"
    sha256 cellar: :any_skip_relocation, ventura:        "fbfc6edccab5443a81062885ade6e71f812997324b4ef360c0815a390c4b0076"
    sha256 cellar: :any_skip_relocation, monterey:       "6f570c918550fc1a30a3e28b54746cf3cafcce1428917c0578d011356f0ef8ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "78b21e49eedc44a25fbd23e97d72eee65faecd834cea08b92bf8f0dfebdb937c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d5769ea0376343694f8d5040b195bef3dfe17dd1f9ef4b6c0812206d3fa9899"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"

    generate_completions_from_executable(bin/"datree", "completion")
  end

  test do
    (testpath/"invalidK8sSchema.yaml").write <<~EOS
      apiversion: v1
      kind: Service
      metadata:
        name: my-service
      spec:
        selector:
          app: MyApp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 9376
    EOS

    assert_match "k8s schema validation error: For field (root): Additional property apiversion is not allowed",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
