class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.4.2.tar.gz"
  sha256 "2d1bef5a219d5bafe76402aa2ccd4f57cadf8a28a8706783211d9b4966f1fe9a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf4fd06a16bec3a91da5d885f56859aeb2cf87a3cd527b7f85df8c062a67139"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6394fee2af5ca8ca6318a773e79ffc0ea691a6baeb4f208a4fd09b5fc7650e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "8bf64aafc66e2a5cd2a7f6b26ebd62d4beb80cedb425eb18aaa1319b2adc4f37"
    sha256 cellar: :any_skip_relocation, big_sur:        "d57afd8bffa859db83b927a899e1049ca7a046a8312acbd67cf406c2a18b5809"
    sha256 cellar: :any_skip_relocation, catalina:       "31fe610bfbb8904936391198cbc595a7ac50d8c99e947706ef7362f1f5038863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464e720217a9db799be24ff6c0feccede3bbca415bdf14971faafc62e07a1041"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "ui"
  end

  service do
    run [opt_bin/"nomad", "agent", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/nomad.log"
    error_log_path var/"log/nomad.log"
  end

  test do
    pid = fork do
      exec "#{bin}/nomad", "agent", "-dev"
    end
    sleep 10
    ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
    system "#{bin}/nomad", "node-status"
  ensure
    Process.kill("TERM", pid)
  end
end
