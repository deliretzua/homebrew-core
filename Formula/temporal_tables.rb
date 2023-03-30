class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "https://pgxn.org/dist/temporal_tables/"
  url "https://github.com/arkhipov/temporal_tables/archive/v1.2.1.tar.gz"
  sha256 "e3711797aa5def8f4974215bb5557204b2bc8e5e94201167eb95246a112b8138"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6f13354123d9d5c6119271e3e665b1a852c063eee2464c70f89e63677091779"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac10885f89785fae6e75daacfc3853918967d4fbb871ef4930e5ac1be8a51ec7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e55f5d41a2f00473e7c17b6d17afe2e06c2f7a878df83983fa6039678058712a"
    sha256 cellar: :any_skip_relocation, ventura:        "31c30c17e0b64fc24092c1fbd4e37e55e27d32e53d1eb703b216ea9587a8c964"
    sha256 cellar: :any_skip_relocation, monterey:       "00646b0b31c19f0b7d3e3fc79838b22bf13594ce596f1730dda2bdd436b830eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "392580073077794d58fa80f777822db79e3f611f7182dc6d6f647b904ede124d"
    sha256 cellar: :any_skip_relocation, catalina:       "25a7565d7644729e8bd0fa1a2626f0a8bb6193d03328295b5fd57791f908a9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65e9ba4630fb2c0db0d7296fec147daa643ec2ab8dad19a56107c1f41637a0fe"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'temporal_tables'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"temporal_tables\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
