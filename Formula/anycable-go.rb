class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.4.1.tar.gz"
  sha256 "3b1bca4a62409c1344d5ad1c40489e1bb2d3fc1bfdb93203642356999290fe96"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11274c77c463ca228c48c072b830126320ef75c1f9741b914051380fabb1152a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11274c77c463ca228c48c072b830126320ef75c1f9741b914051380fabb1152a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11274c77c463ca228c48c072b830126320ef75c1f9741b914051380fabb1152a"
    sha256 cellar: :any_skip_relocation, ventura:        "9785bd24cda73c0dc45be5ee26c3ec6165b4d11b42206f3eb315a04a15375ed1"
    sha256 cellar: :any_skip_relocation, monterey:       "9785bd24cda73c0dc45be5ee26c3ec6165b4d11b42206f3eb315a04a15375ed1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9785bd24cda73c0dc45be5ee26c3ec6165b4d11b42206f3eb315a04a15375ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7fa215813ddf574607f692c111c88cec08f3a4de7dfe97ddb8ddefea3b9201d"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable-go/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable-go/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/anycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
