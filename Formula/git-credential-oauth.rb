class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3c48505c9fc02ef46a5ecadcbc4470a5389d82c7e607448d2d24333726c08809"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6df163cae7e7c4f08503f0bb7e921b352e5f708e12b2e120fe24cf81ebb2b862"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6df163cae7e7c4f08503f0bb7e921b352e5f708e12b2e120fe24cf81ebb2b862"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6df163cae7e7c4f08503f0bb7e921b352e5f708e12b2e120fe24cf81ebb2b862"
    sha256 cellar: :any_skip_relocation, ventura:        "bbd9ef0087ce70758022ca8a89342fa4b92cdaf67119a1c3da1f2965eafa8cc6"
    sha256 cellar: :any_skip_relocation, monterey:       "bbd9ef0087ce70758022ca8a89342fa4b92cdaf67119a1c3da1f2965eafa8cc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbd9ef0087ce70758022ca8a89342fa4b92cdaf67119a1c3da1f2965eafa8cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b157fdfff9f4da00ff85f4a417b0db605b13eb7097e370eb713b117d507a4ad6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_empty shell_output("#{bin}/git-credential-oauth", 2)
  end
end
