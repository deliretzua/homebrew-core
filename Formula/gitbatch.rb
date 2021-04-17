class Gitbatch < Formula
  desc "Manage your git repositories in one place"
  homepage "https://github.com/isacikgoz/gitbatch"
  url "https://github.com/isacikgoz/gitbatch/archive/v0.6.0.tar.gz"
  sha256 "b87b0432b3270a403a10dd8d3c06cd6f7c5a6d2e94c32c0e8410c61124e347e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b456ea020c3f71390fe9678a34f4e4570be60b74b3e72337ab977920b6a34acd"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b4a7e403d40bb05852d24ed69bd68a4498b1ba455d618de879a0a759f6497a6"
    sha256 cellar: :any_skip_relocation, catalina:      "58b204bd1779e99cade465f98457ec14cadaee9a3b65afe099245faba640da0c"
    sha256 cellar: :any_skip_relocation, mojave:        "31d8b72293ceacef7d44beb203887ff80628cb5cd3b56a9f0b467704d153b261"
    sha256 cellar: :any_skip_relocation, high_sierra:   "73fc219e77776b78635c672111736a1ce26f6f1afe0df4ce7c571341578cd1e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gitbatch"
  end

  test do
    mkdir testpath/"repo" do
      system "git", "init"
    end
    assert_match "1 repositories finished", shell_output("#{bin}/gitbatch -q")
  end
end
