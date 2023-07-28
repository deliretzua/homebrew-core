class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.92.0.tar.gz"
  sha256 "259f6fe79e410bab449e1b518b81c95ea982e6d81c4505874b7b973ceec8ff1e"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f69b48e0ea437f7510e3329c3d48266a3ce94ac7fcf9a7f0f08f52628800e7fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4e3713acc5813604bd6b2bae07d672c3d30b6b4a52a511dad651539a2de131"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84187b595e2f966c27cb37af0f9976f97983c13cbdde1b58417fd3c9faf393de"
    sha256 cellar: :any_skip_relocation, ventura:        "5ef9a5347cbaa293663e73d282a796a2c9e9131c2b78dbc6fdd628a6af8bacb6"
    sha256 cellar: :any_skip_relocation, monterey:       "2d78bbbe976dbab560cad218b38dde786aa1fdd630e9c271817ccb08cf5715f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ea6f2af1bcf25875de03a52bdd2c0f2adfdec689a8b981ca165b50b4cc391de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e5dc07628b419925803e0b3fbdbd1d04d4e5b8884aee21804e39861ce63633b"
  end

  depends_on "go" => :build

  def install
    system "make", "victoria-metrics"
    bin.install "bin/victoria-metrics"

    (etc/"victoriametrics/scrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:8428"]
    EOS
  end

  service do
    run [
      opt_bin/"victoria-metrics",
      "-httpListenAddr=127.0.0.1:8428",
      "-promscrape.config=#{etc}/victoriametrics/scrape.yml",
      "-storageDataPath=#{var}/victoriametrics-data",
    ]
    keep_alive false
    log_path var/"log/victoria-metrics.log"
    error_log_path var/"log/victoria-metrics.err.log"
  end

  test do
    http_port = free_port

    (testpath/"scrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    EOS

    pid = fork do
      exec bin/"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}/scrape.yml",
        "-storageDataPath=#{testpath}/victoriametrics-data"
    end
    sleep 3
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
