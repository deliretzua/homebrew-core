class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/v0.5.1.tar.gz"
  sha256 "280403858ea209b41910f487f737fd602b41c60cc6cd3e5cf54ed5db9330b321"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5a9245b1c686e1fcbfa1b39420de21ef91aa3d52d758fa3c7a7bebd877c8bd1"
    sha256 cellar: :any,                 arm64_monterey: "deeb9ef39b6cd14b2d944ab3ce96576bf7ed46f899383b44b4dc4268a506499e"
    sha256 cellar: :any,                 arm64_big_sur:  "da7670a561caf0b12daede67c212a107072ae14d739d435a8b305e835c5599c8"
    sha256 cellar: :any,                 ventura:        "a709925d5ba131a7bc1b3081664fe9ccabdc9ee67b14ed46650557529c305235"
    sha256 cellar: :any,                 monterey:       "6d466ebc3971b3ffcf312ae7499737b4294c50ff1c299f15aee39155d98b6d36"
    sha256 cellar: :any,                 big_sur:        "08f56f87222a86645ff52af4bc041a1ff0152eff98b1403389e8ac19cfdf7e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f833dbfce77ac84caa418a10d61afc5c04e307d6c783bf42d160d79a2e5e6562"
  end

  depends_on "postgresql@15" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-3.23.2.gem"
    sha256 "499ac76d22e86a050e3743a4ca332c84eb5a501a29079849f15c6dfecdbcd00f"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.3.gem"
    sha256 "6b9ee5e2d5aee975588232c41f8203e766157cf71dba54ee85b343a45ced9bfd"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-4.2.1.gem"
    sha256 "b04820a9d1c0c1608e3240b7d84baabbee1b95a7302f29fdd0f00e901c604833"
  end

  resource "slop" do
    url "https://rubygems.org/gems/slop-4.10.1.gem"
    sha256 "844322b5ffcf17ed4815fdb173b04a20dd82b4fd93e3744c88c8fafea696d9c7"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "pgdexter.gemspec"
    system "gem", "install", "--ignore-dependencies", "pgdexter-#{version}.gem"

    bin.install libexec/"bin/dexter"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@15"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      output = shell_output("#{bin}/dexter -d postgres -p #{port} -s SELECT 1 2>&1", 1)
      assert_match "Install HypoPG", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
