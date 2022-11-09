class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.54.0.tar.gz"
  sha256 "d802450fe9aca85b84acc6ea9360c44f5f614a82fe14e7522839242355f53ac5"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ef90ce1f58c2abd8ab22cd103da1d0c160dcb247b91d2aec90b6f6fdd31e8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e173731aff7d3bf857cd5cdf699daef998cdca7f5fae3b041d75d24f9358e3b0"
    sha256 cellar: :any_skip_relocation, monterey:       "675ffaec543b18d17365002dc3a6fcc1c9ea17ab735867bbaaa0d045f1f3db98"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fc5a941efccff50d3705179d912017fdd95be48a0998e2d4b3c8bead7b94e97"
    sha256 cellar: :any_skip_relocation, catalina:       "097ee98d6778d90e93be9d91f787010f7f15fdcdd7c371f736eca70090a7a40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b73c253a4e2ae418df2d848aabd0929af5725490b182ae148d4b89ea190c074"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
