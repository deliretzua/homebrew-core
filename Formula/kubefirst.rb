class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "5e408484d14c483e5f9ca994d680bfb45fee1ee2e64f4d6f40f6747a833a0d53"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9164e2e4d06a8584a6196deb6fb7f57459f9779b7ae8d6a9156a9b4f3dc54fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d105c5baa39535aff1ca7b5f320b8465ef40f9d305ee66aa1fa9c1fe7693d53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b67d9baa26a2b5610f2e324c70d005ab596e176b0905c338185d19a4a42e297"
    sha256 cellar: :any_skip_relocation, ventura:        "a1262fb52295ad17d898db2271e9d5891e6222d51de88c6f44d38c717f370b8b"
    sha256 cellar: :any_skip_relocation, monterey:       "7c318d9ec757b5fb3128ab765747963fe5074ea1f16c82c639bdba69edd4524a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1aa101601b7d623d38b7a93cb42d11ef0066fee79781c884abfa85430f68429e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ecf9a9f287bb652df432654ac7230e0c3aee41cf3180c7c9255351b48494510"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match "v#{version}", shell_output("#{bin}/kubefirst version")
  end
end
