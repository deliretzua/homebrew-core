class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/6.7/questdb-6.7-no-jre-bin.tar.gz"
  sha256 "5316599da6251dfdc335dd20b098049634657049d63bc9692e584d91769c9f19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "54bc839dd7bde6fcf2a8b4c49df194c59d2f27e0a7f90a2d634a5f4c754fa91b"
  end

  depends_on "openjdk@11"

  def install
    rm_rf "questdb.exe"
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env("11")
    inreplace libexec/"questdb.sh", "/usr/local/var/questdb", var/"questdb"
  end

  def post_install
    # Make sure the var/questdb directory exists
    (var/"questdb").mkpath
  end

  service do
    run [opt_bin/"questdb", "start", "-d", var/"questdb", "-n", "-f"]
    keep_alive successful_exit: false
    error_log_path var/"log/questdb.log"
    log_path var/"log/questdb.log"
    working_dir var/"questdb"
  end

  test do
    mkdir_p testpath/"data"
    begin
      fork do
        exec "#{bin}/questdb start -d #{testpath}/data"
      end
      sleep 30
      output = shell_output("curl -Is localhost:9000/index.html")
      sleep 4
      assert_match "questDB", output
    ensure
      system "#{bin}/questdb", "stop"
    end
  end
end
