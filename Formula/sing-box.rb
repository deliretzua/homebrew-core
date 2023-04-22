class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.2.5.tar.gz", using: :homebrew_curl
  sha256 "88d85e8b8a29b165e67b63e4742473d12c49444a659b82ef302113d84bba53ca"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa7667d57aa0b176d5e85031019596401f080b162e2110aa0e1cc85f15fa9355"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa7667d57aa0b176d5e85031019596401f080b162e2110aa0e1cc85f15fa9355"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa7667d57aa0b176d5e85031019596401f080b162e2110aa0e1cc85f15fa9355"
    sha256 cellar: :any_skip_relocation, ventura:        "a2a10cebee8b0d64b203477bbd233f040d091d74d2836cb9001961d46cb29037"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a10cebee8b0d64b203477bbd233f040d091d74d2836cb9001961d46cb29037"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2a10cebee8b0d64b203477bbd233f040d091d74d2836cb9001961d46cb29037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29da0b2261932073d934bb56174c774f6a446ba265d22401bc6a4650f7d773f5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~EOS
      {
        "inbounds": [
          {
            "type": "shadowsocks",
            "listen": "::",
            "listen_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    EOS
    server = fork { exec "#{bin}/sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

    sing_box_port = free_port
    (testpath/"config.json").write <<~EOS
      {
        "inbounds": [
          {
            "type": "mixed",
            "listen": "::",
            "listen_port": #{sing_box_port}
          }
        ],
        "outbounds": [
          {
            "type": "shadowsocks",
            "server": "127.0.0.1",
            "server_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    EOS
    system "#{bin}/sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec "#{bin}/sing-box", "run", "-D", testpath, "-c", "config.json" }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
