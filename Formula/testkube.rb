class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.13.3.tar.gz"
  sha256 "a49d953a8b15203b4ecb76802c15e385e0d9440e8263f35c05c2c55d1cacd2c7"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ef1df34f5cf5e8a8f4b9713540393c491fa1c29d994b56f207f23174b286d30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ef1df34f5cf5e8a8f4b9713540393c491fa1c29d994b56f207f23174b286d30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ef1df34f5cf5e8a8f4b9713540393c491fa1c29d994b56f207f23174b286d30"
    sha256 cellar: :any_skip_relocation, ventura:        "fc4a93fa8cfc3c38a57cf927d2ce32a2323b1021489c3803c64bbd55aec42118"
    sha256 cellar: :any_skip_relocation, monterey:       "fc4a93fa8cfc3c38a57cf927d2ce32a2323b1021489c3803c64bbd55aec42118"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc4a93fa8cfc3c38a57cf927d2ce32a2323b1021489c3803c64bbd55aec42118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "695e5bad66df0f93e1af3b0d2a9766f732e25b9eb7dc137ad2390b5a3e7abf9e"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
