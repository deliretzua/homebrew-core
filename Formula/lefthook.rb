class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "b02085764aa2668c877cff8844bbf07ca1a9d87dccd76445b000f16b32e792ad"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84d26ff9cdc96cb08511097cd81fc7908a8c4b57dd3b8dd64eaba715c8b22d80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84d26ff9cdc96cb08511097cd81fc7908a8c4b57dd3b8dd64eaba715c8b22d80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84d26ff9cdc96cb08511097cd81fc7908a8c4b57dd3b8dd64eaba715c8b22d80"
    sha256 cellar: :any_skip_relocation, ventura:        "5b64a614939ff16c29b6ab8117c1e5a0bbd80ddb9251665320df5920ac48fa98"
    sha256 cellar: :any_skip_relocation, monterey:       "5b64a614939ff16c29b6ab8117c1e5a0bbd80ddb9251665320df5920ac48fa98"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b64a614939ff16c29b6ab8117c1e5a0bbd80ddb9251665320df5920ac48fa98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e69270f6d2ea41063c9f3e92fe04e2983d897dee11ea9c0d30d2e8a9c45285"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
