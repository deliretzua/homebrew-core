class Solr < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://solr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=lucene/solr/8.11.1/solr-8.11.1.tgz"
  mirror "https://archive.apache.org/dist/lucene/solr/8.11.1/solr-8.11.1.tgz"
  sha256 "9ec540cbd8e45f3d15a6b615a22939f5e6242ca81099951a47d3c082c79866a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7621f424db5174a69c1f1fef6c102356490f73a840cc57a29ce2cb2f33da3d1"
  end

  depends_on :macos # test failed on linux
  depends_on "openjdk"

  def install
    pkgshare.install "bin/solr.in.sh"
    (var/"lib/solr").install "server/solr/README.txt", "server/solr/solr.xml", "server/solr/zoo.cfg"
    prefix.install %w[contrib dist server]
    libexec.install "bin"
    bin.install [libexec/"bin/solr", libexec/"bin/post", libexec/"bin/oom_solr.sh"]

    env = Language::Java.overridable_java_home_env
    env["SOLR_HOME"] = "${SOLR_HOME:-#{var/"lib/solr"}}"
    env["SOLR_LOGS_DIR"] = "${SOLR_LOGS_DIR:-#{var/"log/solr"}}"
    env["SOLR_PID_DIR"] = "${SOLR_PID_DIR:-#{var/"run/solr"}}"
    bin.env_script_all_files libexec, env
    (libexec/"bin").rmtree

    inreplace libexec/"solr", "/usr/local/share/solr", pkgshare
  end

  def post_install
    (var/"run/solr").mkpath
    (var/"log/solr").mkpath
  end

  service do
    run [opt_bin/"solr", "start", "-f", "-s", HOMEBREW_PREFIX/"var/lib/solr"]
    working_dir HOMEBREW_PREFIX
  end

  test do
    ENV["SOLR_PID_DIR"] = testpath
    port = free_port

    # Info detects no Solr node => exit code 3
    shell_output(bin/"solr -i", 3)
    # Start a Solr node => exit code 0
    shell_output(bin/"solr start -p #{port} -Djava.io.tmpdir=/tmp")
    # Info detects a Solr node => exit code 0
    shell_output(bin/"solr -i")
    # Impossible to start a second Solr node on the same port => exit code 1
    shell_output(bin/"solr start -p #{port}", 1)
    # Stop a Solr node => exit code 0
    shell_output(bin/"solr stop -p #{port}")
    # No Solr node left to stop => exit code 1
    shell_output(bin/"solr stop -p #{port}", 1)
  end
end
