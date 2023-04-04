class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "6896dddd06e0756df54f2678c77e3eea45354b2ae167ccec1de8352f0554b8cb"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a09af1c30477e67de05008534850c930d513eee2189be1cdefb22bf788e88653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61088bdb72e8f3bd0effd3b4e7dd8256a615179ed36d365ca75887812d01c41f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf47f5643cb7075f1912a67a354b671cf78cc2683066ddc92e784dc20b234cd8"
    sha256 cellar: :any_skip_relocation, ventura:        "976f9434e7d01d98b5ad69c19eb35928b4e3fbbf4a31a7d8f49ba0357153ab53"
    sha256 cellar: :any_skip_relocation, monterey:       "4a57ec81d232c8a0a0293f352ee3e12c1db10bbef82de1700d83e26c7a1becd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "15da3d8fbbab727d434bee8d13050e7c008b6bdc41d1bc92cc3deee01018e7f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2131a845151bccfd65d829a5114843306b14eac9f2a6fba061b7712326769eb0"
  end

  depends_on "go" => :build

  # Fix an undefined symbol error on Apple Silicon.
  # Remove when `github.com/shoenig/go-m1cpu` v0.1.5 is used by upstream.
  on_macos do
    on_arm do
      patch :DATA
    end
  end

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/telegraf"
    (etc/"telegraf.conf").write Utils.safe_popen_read("#{bin}/telegraf", "config")
  end

  def post_install
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end

__END__
--- a/go.mod
+++ b/go.mod
@@ -388,7 +388,7 @@ require (
 	github.com/rogpeppe/fastuuid v1.2.0 // indirect
 	github.com/russross/blackfriday/v2 v2.1.0 // indirect
 	github.com/samuel/go-zookeeper v0.0.0-20200724154423-2164a8ac840e // indirect
-	github.com/shoenig/go-m1cpu v0.1.4 // indirect
+	github.com/shoenig/go-m1cpu v0.1.5 // indirect
 	github.com/signalfx/com_signalfx_metrics_protobuf v0.0.3 // indirect
 	github.com/signalfx/gohistogram v0.0.0-20160107210732-1ccfd2ff5083 // indirect
 	github.com/signalfx/sapm-proto v0.7.2 // indirect
--- a/go.sum
+++ b/go.sum
@@ -2062,6 +2062,8 @@ github.com/shirou/gopsutil/v3 v3.23.3 h1:Syt5vVZXUDXPEXpIBt5ziWsJ4LdSAAxF4l/xZeQ
 github.com/shirou/gopsutil/v3 v3.23.3/go.mod h1:lSBNN6t3+D6W5e5nXTxc8KIMMVxAcS+6IJlffjRRlMU=
 github.com/shoenig/go-m1cpu v0.1.4 h1:SZPIgRM2sEF9NJy50mRHu9PKGwxyyTTJIWvCtgVbozs=
 github.com/shoenig/go-m1cpu v0.1.4/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
+github.com/shoenig/go-m1cpu v0.1.5 h1:LF57Z/Fpb/WdGLjt2HZilNnmZOxg/q2bSKTQhgbrLrQ=
+github.com/shoenig/go-m1cpu v0.1.5/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
 github.com/shoenig/test v0.6.3 h1:GVXWJFk9PiOjN0KoJ7VrJGH6uLPnqxR7/fe3HUPfE0c=
 github.com/shoenig/test v0.6.3/go.mod h1:byHiCGXqrVaflBLAMq/srcZIHynQPQgeyvkvXnjqq0k=
 github.com/shopspring/decimal v0.0.0-20180709203117-cd690d0c9e24/go.mod h1:M+9NzErvs504Cn4c5DxATwIqPbtswREoFCre64PpcG4=
