class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.0.4.tar.gz"
  sha256 "98248e2763907d9b7a9fcfde67fe395e868cd8780246cb274f858c8440a856bc"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee40011c6d573f3f567adeec8098428d602580fec188af1191027380b0017989"
    sha256 cellar: :any_skip_relocation, big_sur:       "4fad3cde32a0582f7c67e5b1c1cf042b26440550adbea601b8e47a8391628763"
    sha256 cellar: :any_skip_relocation, catalina:      "c9524a91cef04b327a268ed84a95bde54adaf82b82527bb3e086382c81fc6798"
    sha256 cellar: :any_skip_relocation, mojave:        "3ca5d2a4a546fda4da5e840ef21f80494bcc0fd1df3890040cb63fcfc59911eb"
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

    system "go", "build", "-mod=vendor", "-ldflags", ldflags.join(" "), *std_go_args,
                          "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
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
