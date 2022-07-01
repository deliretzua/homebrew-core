class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20220628.tar.gz"
  sha256 "6a63facc902594b4ca5f0456e58196cf7b2a2451594fe2f69b55ac712ceb85e8"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd7100a62dee2ca46b25ebd4fccf13d4db334720447d4c9258b8ba5df97ae8c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c97a883e2048b359e651f507f30253737d2321e4fc1a395d974cc77393e0fe6e"
    sha256 cellar: :any_skip_relocation, monterey:       "6e452d0353373527bc2f8e3d775dc334d08e378526c78bf5ffdef76de296f953"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ad1270e0bba0a7dc12310895df5d16387fe419368e6cfc6a374d818f9c1678b"
    sha256 cellar: :any_skip_relocation, catalina:       "445130c0d80589759e05859e2e999335eed7a00a845709c659432c54773d3a35"
    sha256 cellar: :any_skip_relocation, mojave:         "d2b5d0001b6afed4dcf1804930bc47a8b3df26e75717e18319e38c2b9ebba890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5d892ce0ccf516f9252e9f09eaa56896021a12ea4d14003d69dabc7559a4467"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kcptun_client"), "./client"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kcptun_server"), "./server"

    etc.install "examples/local.json" => "kcptun_client.json"
  end

  service do
    run [opt_bin/"kcptun_client", "-c", etc/"kcptun_client.json"]
    keep_alive true
    log_path var/"log/kcptun.log"
    error_log_path var/"log/kcptun.log"
  end

  test do
    server = fork { exec bin/"kcptun_server", "-t", "1.1.1.1:80" }
    client = fork { exec bin/"kcptun_client", "-r", "127.0.0.1:29900", "-l", ":12948" }
    sleep 1
    begin
      assert_match "cloudflare", shell_output("curl -vI http://127.0.0.1:12948/")
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
