class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.9",
      revision: "e5f1194a6de78cc1124179a4c9bb1ae3484fb77d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b1a8b4cc13067388cba0d49d39763dc015777b2eeeb33052c22025d0f3b772a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3db13cab805ad63d2611d923a284cb0ba0b46f97a3d45552799ce38e874a082"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64331ed8547ffa34bb596b50c2ad59abf59a7289519a0aa76d9797f9f97a8fb4"
    sha256 cellar: :any_skip_relocation, ventura:        "21da5d35ae7994c30b752bc7d2fccaef94fa4b320956004e7e654bdbb2c379a0"
    sha256 cellar: :any_skip_relocation, monterey:       "9036b50bac5bf1fa2297e1ca60ef6c67f50cdbbdb0beda8f81d3f6dfcc32d7aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "564395b77bad0380b99799a86eb38acd4fc457a03ca1f386fb2d6971951713a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90afbdfef397c4934cec9f0cd02dee32ceef870bf0e37471a7caa626daf4f7d3"
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
