class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.2.0.tar.gz"
  sha256 "fca2d79dc616b52f3fddd1bc19e6e11d2496ed048c2ca90c6a30d1fbf1b6c20d"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8bb757471782b9f7bbfe028dc8039c35f0e07182e74dae9ca9c7b923b9ba7568"
    sha256 cellar: :any_skip_relocation, big_sur:       "48e5ce9c0aac69f8ca0f27db652227900df5c772472bb391b8702457ecfe0caf"
    sha256 cellar: :any_skip_relocation, catalina:      "42c81987bbcffffee20ece6c4534a77612496c2b082723681f4468eab7a0fd61"
    sha256 cellar: :any_skip_relocation, mojave:        "c5e96271283bee73b7ff9cfa68f6d1f566765bf2e41374c67ae66c51e502e2d8"
    sha256 cellar: :any_skip_relocation, high_sierra:   "e4d101f7ea1263dabd9a95a3b90925082a003274d1a45c2168b4bf7bbb8a1fa1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  plist_options manual: "nats-server"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/nats-server</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{port}")
    assert_predicate testpath/"log", :exist?
  end
end
