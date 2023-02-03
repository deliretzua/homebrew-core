class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.128.0",
      revision: "988e9835dafc9dcbc7c4980f61ad2955a7615a48"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "703f446f62b166aa5e139549c95a398226c14f19905a1b80480169611eba00f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf0d53806155bda0b1b4daf9d3f7d9a85ea35e4dfe7a66d0f58536508aa3ce58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed0c2573fa4aed6d47e481328460118f5cb14378b201f31392b7fdaf2b28fc7a"
    sha256 cellar: :any_skip_relocation, ventura:        "3aadfc06260d368fdafd1d1da14a7ade1c374bf2102899f06fcbdea3a9ad176e"
    sha256 cellar: :any_skip_relocation, monterey:       "407d55f05ef57ea006982de40e8ebf733f2d51ce0c3103c32a0ab9ac71eed600"
    sha256 cellar: :any_skip_relocation, big_sur:        "1931a04d848b4e44a8c6995c0caebf0108813d4c599cae4723324d46e77a3bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1add24c5e4d14deafbcb51072ad354a0311894fc46f1dc3babfa5566f3feb16"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # Eksctl requires newer version of ifacemaker
  #
  # Replace with `depends_on "ifacemaker" => :build` when ifacemaker > 1.2.0
  # Until then get the resource version from go.mod
  resource "ifacemaker" do
    url "https://github.com/vburenin/ifacemaker/archive/b2018d8549dc4d51ce7e2254d6b0a743643613be.tar.gz"
    sha256 "41888bf97133b4e7e190f2040378661b5bcab290d009e1098efbcb9db0f1d82f"
  end

  def install
    resource("ifacemaker").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: buildpath/"ifacemaker")
    end
    inreplace "build/scripts/generate-aws-interfaces.sh", "${GOBIN}/ifacemaker",
                                                          buildpath/"ifacemaker"

    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
