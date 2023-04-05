class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.9",
      revision: "eab56bf96052640fd755dd7886855ece246c6838"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57f4c6b2f52f55333467ffdd4cb42e5e1a4189097b917bd1b1abcec06472278c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57f4c6b2f52f55333467ffdd4cb42e5e1a4189097b917bd1b1abcec06472278c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57f4c6b2f52f55333467ffdd4cb42e5e1a4189097b917bd1b1abcec06472278c"
    sha256 cellar: :any_skip_relocation, ventura:        "74650e6230e95a756aa049c33229454b7744f71c09dc7a324a7174e48fe1c6ed"
    sha256 cellar: :any_skip_relocation, monterey:       "74650e6230e95a756aa049c33229454b7744f71c09dc7a324a7174e48fe1c6ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "74650e6230e95a756aa049c33229454b7744f71c09dc7a324a7174e48fe1c6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11b717f5fb4d88c86d77ab6f07d9df4c8485a6929685e724fd3fe1f5a56a316b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
