class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.16.tar.gz"
  sha256 "7aa3b741ca44595cf8113b40a161aa8bf55a1ecf338af7d1d078337f9212e9a6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9bad540c5e1122e2b6f94bfc8401cb3e4ec5a87beb7f85b67637d8adf0f876e4"
    sha256 cellar: :any,                 big_sur:       "aa7ce60364d343a7c643c2d667ef6a447a0c0d062d30d3ad25b7d4d141f569ff"
    sha256 cellar: :any,                 catalina:      "b9b7b70e46c81533e46032a90b8c8f23395ac5a15eb89c3dd8aadbf2b4c266af"
    sha256 cellar: :any,                 mojave:        "eae3a12f74750e5b7593e4ef3aa1f7ba3173f4cf31ccc8a4bb865b010de098f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9981200e9463afd12fda01cb24906b2c670850209d08e71a0947b0bf742138e1"
  end

  depends_on "libevent"

  def install
    system "make"
    bin.install "webdis"

    inreplace "webdis.prod.json" do |s|
      s.gsub! "/var/log/webdis.log", "#{var}/log/webdis.log"
      s.gsub!(/daemonize":\s*true/, "daemonize\":\tfalse")
    end

    etc.install "webdis.json", "webdis.prod.json"
  end

  def post_install
    (var/"log").mkpath
  end

  plist_options manual: "webdis #{HOMEBREW_PREFIX}/etc/webdis.json"

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
              <string>#{opt_bin}/webdis</string>
              <string>#{etc}/webdis.prod.json</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <dict>
              <key>SuccessfulExit</key>
              <false/>
          </dict>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    cp "#{etc}/webdis.json", "#{testpath}/webdis.json"
    inreplace "#{testpath}/webdis.json", "\"http_port\":\t7379,", "\"http_port\":\t#{port},"

    server = fork do
      exec "#{bin}/webdis", "#{testpath}/webdis.json"
    end
    sleep 0.5
    # Test that the response is from webdis
    assert_match(/Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:#{port}/PING"))
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
