class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.10",
      revision: "d311fad538178ef97528edf7f09d1d5b57268f45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f33a63593c4ab244420c29a93926b5f07530ebc04dd3e70fbc14af76d3743eba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ca0d3b83b36a165ba631830d4d5e6b4a486d714509c54c9043a93dbd0ff20ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a456d8dd764747ad5428346203de4e54ad3a5fb46df16db1f5b18a390370d46"
    sha256 cellar: :any_skip_relocation, ventura:        "2fdecc6a05c6feb625f24fe49cf4529d34389cbc06d6cd886ac013043ab7f0d0"
    sha256 cellar: :any_skip_relocation, monterey:       "513fa93010c94dc74d34d53292336e3e81a61cc32636b09fb83f9f1bff7c01a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ba77294701931285221d7020741dc8654c057d9ef435e5b2ec16c29c1c2fcb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62abe490b2c3d590d3ef7734aa021c11f82a6703b2b6e11e4b902a8cecd4fc9c"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
