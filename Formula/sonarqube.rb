class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.6.0.59041.zip"
  sha256 "e3c21ba1f6a53f766e4ab56a484ddedbba9ebd31e82a1999e618ee5ffb73e5f2"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarqube.org/success-download-community-edition/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf217559602d1d83e6e3157ab60e379e1c79b59d5dcb16aab87dcabb75ab29d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf217559602d1d83e6e3157ab60e379e1c79b59d5dcb16aab87dcabb75ab29d6"
    sha256 cellar: :any_skip_relocation, monterey:       "6a398ceb838b5a35beb5989ec9f0e1ab847957c77eae0064f3359f2fa6929f4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a398ceb838b5a35beb5989ec9f0e1ab847957c77eae0064f3359f2fa6929f4f"
    sha256 cellar: :any_skip_relocation, catalina:       "6a398ceb838b5a35beb5989ec9f0e1ab847957c77eae0064f3359f2fa6929f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0460aad08ae421d32fa9eeeda1b6abfa395a605aa2e274d7054e17f872d93be6"
  end

  depends_on "openjdk@11"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\./\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/run/\$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("11")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"sonar").write_env_script libexec/"bin"/platform/"sonar.sh", env
  end

  def post_install
    (var/"run").mkpath
    (var/"sonarqube/logs").mkpath
  end

  def caveats
    <<~EOS
      Data: #{var}/sonarqube/data
      Logs: #{var}/sonarqube/logs
      Temp: #{var}/sonarqube/temp
    EOS
  end

  service do
    run [opt_bin/"sonar", "console"]
    keep_alive true
  end

  test do
    port = free_port
    ENV["SONAR_WEB_PORT"] = port.to_s
    ENV["SONAR_EMBEDDEDDATABASE_PORT"] = free_port.to_s
    ENV["SONAR_SEARCH_PORT"] = free_port.to_s
    ENV["SONAR_PATH_DATA"] = testpath/"data"
    ENV["SONAR_PATH_LOGS"] = testpath/"logs"
    ENV["SONAR_PATH_TEMP"] = testpath/"temp"
    ENV["SONAR_TELEMETRY_ENABLE"] = "false"

    assert_match(/SonarQube.* is not running/, shell_output("#{bin}/sonar status", 1))
    pid = fork { exec bin/"sonar", "console" }
    begin
      sleep 15
      output = shell_output("#{bin}/sonar status")
      assert_match(/SonarQube is running \([0-9]*?\)/, output)
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
