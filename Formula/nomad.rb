class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.6.0.tar.gz"
  sha256 "e1a5180e348564d2f7ccdada31dc089e371562b8fc2eebdd7541e01d1be4a1a8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83916087137e1970b684e64e148e9765f849de2404c925abdc051a992be27b9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c555aa12b7cb3f0cced328a0c8fcfb24d998c7638fe2b102cf496d9a8b46882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "442f60009df3dae052b316ddab40e8f0071735516fd46c6fc586f68ad8479eb0"
    sha256 cellar: :any_skip_relocation, ventura:        "6f000ae9cf1ca22447a6d25889bca3fc9d00cf98bd6702dd37295aad50624130"
    sha256 cellar: :any_skip_relocation, monterey:       "2ff4ac4aa52f840a8b89ab59ee2ed1226a54936b567c2dfea4b1d0914a24ef6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "608d7940fddd2addf5f12699b3c9cc74a020f5427411c55f17898abfe5ed13d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af4d16c4962673a4bf2ef3333952f0b77116a21a42edfa8405f4680a63f196cc"
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
