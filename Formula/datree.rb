class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.49.tar.gz"
  sha256 "ddde35fc13f31554b30225546172ba06ae10baa5e6e3151f2e51e72035724620"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac82d74545e255a7c102e5287244271845a88008834def992de8755d1608fe00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93205578d61b8d1639f8041996e722ec0165f13c2e19dd5fb861e190ad270e36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6584e46ca3142f574891f23732223f1727b9e653676b72456b0286fc2cd50315"
    sha256 cellar: :any_skip_relocation, ventura:        "21b7c843cc12fdb0ac1d5857ff42b992c57220f46f9f414b881baa8d90814fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "d773c04e85de0abce761b222bc30897b1cd651fbe4f0ffc5cc87805eeb0d2141"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6011d5c7212e1a3b287c281c40c76f387159eea56dbe77c6bfa1a3fed3eac98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c41b0db91d8c3b6eda8405a7c6f0c12d99d963381ed1857036dc6ea95d9f7ab1"
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
