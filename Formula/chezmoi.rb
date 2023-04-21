class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.33.2",
      revision: "ebc536f0dbf7c54ab8677b202532736be8d61c6c"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1385c9fd4b92403698f6e8d85486e6b72d74bcd07e53e75ab1b1b1da5394cf33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e0e973644e4310290b0a3a565713e5fd7958d20bad45251180a2902c7964d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2313af9b5ba735b66a4a688d12496a3e0b6c92de57e32071b3cfc3119b3b2955"
    sha256 cellar: :any_skip_relocation, ventura:        "168e73c59f6ed382242d05af93ab982d0772b4330fe3035b3a6ef1bb675123df"
    sha256 cellar: :any_skip_relocation, monterey:       "56d7628ea96738b3527c108910682596cb88b970ff1f34345569d81debdb7af5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2bce9270132adfc542c6bfcd1ca87465f059d8995a656a0f7a12491474f385d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acaeb528fffc6f48276a93e9455955588f5b11e4bfe51bdc0d8a0e518972bf28"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
