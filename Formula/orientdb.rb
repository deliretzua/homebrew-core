class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.org/"
  url "https://s3.us-east-2.amazonaws.com/orientdb3/releases/3.1.10/orientdb-3.1.10.zip"
  sha256 "b3223fc265e737d612aaf8089df3a153f2a68f920c8ff7aa1a3c682b087aa9d3"
  license "Apache-2.0"

  livecheck do
    url "https://orientdb.org/download"
    regex(/href=.*?orientdb[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e1106b08519ba3040cc110059076200288d65b7ef8a1229b3780cfe587aa7a11"
    sha256 cellar: :any_skip_relocation, big_sur:       "fff6a6252f2ab3d00dc21c7c0f8b7e1ab42a14bbd243ed091c906e683c929621"
    sha256 cellar: :any_skip_relocation, catalina:      "3049e947d195bc00cd6ec2f6f6054ec27db4d8a35161a1be712c3cfa358dfe7f"
    sha256 cellar: :any_skip_relocation, mojave:        "55bb33a1c52cdc859a34c90fc1c690fec0dd897f99881e9a1932f314a81644f2"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]

    chmod 0755, Dir["bin/*"]
    libexec.install Dir["*"]

    inreplace "#{libexec}/config/orientdb-server-config.xml", "</properties>",
       <<~EOS
         <entry name="server.database.path" value="#{var}/db/orientdb" />
         </properties>
       EOS
    inreplace "#{libexec}/config/orientdb-server-log.properties", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/orientdb.sh", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/server.sh", "ORIENTDB_PID=$ORIENTDB_HOME/bin", "ORIENTDB_PID=#{var}/run/orientdb"
    inreplace "#{libexec}/bin/shutdown.sh", "ORIENTDB_PID=$ORIENTDB_HOME/bin", "ORIENTDB_PID=#{var}/run/orientdb"
    inreplace "#{libexec}/bin/orientdb.sh", '"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec
    inreplace "#{libexec}/bin/orientdb.sh", 'su $ORIENTDB_USER -c "cd \"$ORIENTDB_DIR/bin\";', ""
    inreplace "#{libexec}/bin/orientdb.sh", '&"', "&"

    (bin/"orientdb").write_env_script "#{libexec}/bin/orientdb.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin/"orientdb-console").write_env_script "#{libexec}/bin/console.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin/"orientdb-gremlin").write_env_script "#{libexec}/bin/gremlin.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  def post_install
    (var/"db/orientdb").mkpath
    (var/"run/orientdb").mkpath
    (var/"log/orientdb").mkpath
    touch "#{var}/log/orientdb/orientdb.err"
    touch "#{var}/log/orientdb/orientdb.log"

    ENV["ORIENTDB_ROOT_PASSWORD"] = "orientdb"
    system "#{bin}/orientdb", "stop"
    sleep 3
    system "#{bin}/orientdb", "start"
    sleep 3
  ensure
    system "#{bin}/orientdb", "stop"
  end

  def caveats
    <<~EOS
      The OrientDB root password was set to 'orientdb'. To reset it:
        https://orientdb.org/docs/3.1.x/security/Server-Security.html#restoring-the-servers-user-root
    EOS
  end

  plist_options manual: "orientdb start"

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
          <string>homebrew.mxcl.orientdb</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{HOMEBREW_PREFIX}/opt/orientdb/libexec/bin/server.sh</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>/usr/local/var</string>
          <key>StandardErrorPath</key>
          <string>/usr/local/var/log/orientdb/serror.log</string>
          <key>StandardOutPath</key>
          <string>/usr/local/var/log/orientdb/sout.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    ENV["CONFIG_FILE"] = "#{testpath}/orientdb-server-config.xml"
    ENV["ORIENTDB_ROOT_PASSWORD"] = "orientdb"

    cp "#{libexec}/config/orientdb-server-config.xml", testpath
    inreplace "#{testpath}/orientdb-server-config.xml", "</properties>",
      "  <entry name=\"server.database.path\" value=\"#{testpath}\" />\n    </properties>"

    assert_match "OrientDB console v.#{version}", pipe_output("#{bin}/orientdb-console \"exit;\"")
  end
end
