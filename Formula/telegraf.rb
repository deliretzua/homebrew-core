class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.19.2.tar.gz"
  sha256 "a92de0b9b30d6dd4348ea5b05c0883d95149afb4add452a249e1fbe903025dd9"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "328bff7e65a271846295ea0e81c3ee58efb5ce3399f1720b4f299b63a80cb6a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "b5f5cdc0bcd37e9acd5a40f0dd1a30ab2b73a748806cef0e2b5fc9fbe9f13479"
    sha256 cellar: :any_skip_relocation, catalina:      "4f833c5f38a99a8c45a80544eb7b398132c27a9ca31dd26d595c5f3e882f571b"
    sha256 cellar: :any_skip_relocation, mojave:        "b96e19f8f6a231f8217377e6408d1d4374f346fd568b11e29e8ca87fef0dd548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3266d4c2fbe6d65dd108e1fda402ba1f608ac09cab665b16d5c7cc108dabfac6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/telegraf"
    etc.install "etc/telegraf.conf" => "telegraf.conf"
  end

  def post_install
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  plist_options manual: "telegraf -config #{HOMEBREW_PREFIX}/etc/telegraf.conf"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/telegraf</string>
            <string>-config</string>
            <string>#{etc}/telegraf.conf</string>
            <string>-config-directory</string>
            <string>#{etc}/telegraf.d</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/telegraf.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/telegraf.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
