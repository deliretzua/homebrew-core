class Cassandra < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Eventually consistent, distributed key-value store"
  homepage "https://cassandra.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=cassandra/4.1.3/apache-cassandra-4.1.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/cassandra/4.1.3/apache-cassandra-4.1.3-bin.tar.gz"
  sha256 "da014999723f4e1e2c15775dac6aaa9ff69a48f6df6465740fcd52ca9d19ea88"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b012f5d71b9fc2c7f16368d154e7041c87a06680f82ce6bfb5fae944a278ecc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "215d166ef9f452ba489f2e308cecf88ba397441754950ccc3ac2baf62314daba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07c2391a2dbdcaefa39ad5f3b430142c997db6a3d590653f4c014126e348cbd9"
    sha256 cellar: :any_skip_relocation, ventura:        "50f16014aaf08aa2eb5edf520bd07d356aafd7a1e5051d7c28c698e95b7b0758"
    sha256 cellar: :any_skip_relocation, monterey:       "d2242ba79bc2b8dd99b8444a17fee39b1169e196976f41b93cfbf1e99ea080c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bffc579a3d0948e77d744acd57dc70a231a49a18036fe9bf3bff69b025faa3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75dad73109101069465c04f8b5b4476720199220e42fac8085f0219357745f60"
  end

  depends_on "libcython" => :build
  depends_on "openjdk@11"
  depends_on "python@3.11"
  depends_on "six"

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/f5/ab/417dc6c1bfea24042c97e381036b02864db8d918d3f65926e1884b98f086/cassandra-driver-3.28.0.tar.gz"
    sha256 "64ff130d19f994b80997c14343a8306be52a0e7ab92520a534eed944c88d70df"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/7a/27/f6fc66e0629cfdcd301ebcb737b55041c238742420dce7728f208d75731c/geomet-1.0.0.tar.gz"
    sha256 "0020a4426469934fb58f541cdc23f27c0c0fbbb3d003ee2cb76bb7ffa96a7506"
  end

  def install
    (var/"lib/cassandra").mkpath
    (var/"log/cassandra").mkpath

    python3 = "python3.11"
    venv = virtualenv_create(libexec/"vendor", python3)
    venv.pip_install resources

    inreplace "conf/cassandra.yaml", "/var/lib/cassandra", var/"lib/cassandra"
    inreplace "conf/cassandra-env.sh", "/lib/", "/"

    inreplace "bin/cassandra", "-Dcassandra.logdir=$CASSANDRA_LOG_DIR",
                               "-Dcassandra.logdir=#{var}/log/cassandra"
    inreplace "bin/cassandra.in.sh" do |s|
      s.gsub! "CASSANDRA_HOME=\"`dirname \"$0\"`/..\"",
              "CASSANDRA_HOME=\"#{libexec}\""
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=\"$CASSANDRA_HOME/conf\"",
              "CASSANDRA_CONF=\"#{etc}/cassandra\""
      # Jars installed to prefix, no longer in a lib folder
      s.gsub! "\"$CASSANDRA_HOME\"/lib/*.jar",
              "\"$CASSANDRA_HOME\"/*.jar"
      # The jammm Java agent is not in a lib/ subdir either:
      s.gsub! "JAVA_AGENT=\"$JAVA_AGENT -javaagent:$CASSANDRA_HOME/lib/jamm-",
              "JAVA_AGENT=\"$JAVA_AGENT -javaagent:$CASSANDRA_HOME/jamm-"
      # Storage path
      s.gsub! "cassandra_storagedir=\"$CASSANDRA_HOME/data\"",
              "cassandra_storagedir=\"#{var}/lib/cassandra\""

      s.gsub! "#JAVA_HOME=/usr/local/jdk6",
              "JAVA_HOME=#{Language::Java.overridable_java_home_env("11")[:JAVA_HOME]}"
    end

    rm Dir["bin/*.bat", "bin/*.ps1"]

    # This breaks on `brew uninstall cassandra && brew install cassandra`
    # https://github.com/Homebrew/homebrew/pull/38309
    pkgetc.install Dir["conf/*"]

    libexec.install Dir["*.txt", "{bin,interface,javadoc,pylib,lib/licenses}"]
    libexec.install Dir["lib/*.jar"]

    pkgshare.install [libexec/"bin/cassandra.in.sh", libexec/"bin/stop-server"]
    inreplace Dir[
      libexec/"bin/cassandra*",
      libexec/"bin/debug-cql",
      libexec/"bin/nodetool",
      libexec/"bin/sstable*",
    ], %r{`dirname "?\$0"?`/cassandra.in.sh},
       pkgshare/"cassandra.in.sh"

    # Make sure tools are installed
    rm Dir[buildpath/"tools/bin/*.bat"] # Delete before install to avoid copying useless files
    (libexec/"tools").install Dir[buildpath/"tools/lib/*.jar"]

    # Tools use different cassandra.in.sh and should be changed differently
    mv buildpath/"tools/bin/cassandra.in.sh", buildpath/"tools/bin/cassandra-tools.in.sh"
    inreplace buildpath/"tools/bin/cassandra-tools.in.sh" do |s|
      # Tools have slightly different path to CASSANDRA_HOME
      s.gsub! "CASSANDRA_HOME=\"`dirname $0`/../..\"", "CASSANDRA_HOME=\"#{libexec}\""
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=\"$CASSANDRA_HOME/conf\"", "CASSANDRA_CONF=\"#{etc}/cassandra\""
      # Core Jars installed to prefix, no longer in a lib folder
      s.gsub! "\"$CASSANDRA_HOME\"/lib/*.jar", "\"$CASSANDRA_HOME\"/*.jar"
      # Tools Jars are under tools folder
      s.gsub! "\"$CASSANDRA_HOME\"/tools/lib/*.jar", "\"$CASSANDRA_HOME\"/tools/*.jar"
      # Storage path
      s.gsub! "cassandra_storagedir=\"$CASSANDRA_HOME/data\"", "cassandra_storagedir=\"#{var}/lib/cassandra\""
    end

    pkgshare.install [buildpath/"tools/bin/cassandra-tools.in.sh"]

    # Update tools script files
    inreplace Dir[buildpath/"tools/bin/*"],
              "`dirname \"$0\"`/cassandra.in.sh",
              pkgshare/"cassandra-tools.in.sh"

    venv_bin = libexec/"vendor/bin"
    rw_info = python_shebang_rewrite_info(venv_bin/python3)
    rewrite_shebang rw_info, libexec/"bin/cqlsh.py"

    # Make sure tools are available
    bin.install Dir[buildpath/"tools/bin/*"]
    bin.write_exec_script Dir[libexec/"bin/*"]
    (bin/"cqlsh").write_env_script libexec/"bin/cqlsh", PATH: "#{venv_bin}:$PATH"
  end

  service do
    run [opt_bin/"cassandra", "-f"]
    keep_alive true
    working_dir var/"lib/cassandra"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cassandra -v")

    output = shell_output("#{bin}/cqlsh localhost 2>&1", 1)
    assert_match "Connection error", output
  end
end
