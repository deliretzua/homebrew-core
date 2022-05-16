require "language/perl"

class Sslmate < Formula
  include Language::Perl::Shebang
  include Language::Python::Virtualenv

  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.9.1.tar.gz"
  sha256 "179b331a7d5c6f0ed1de51cca1c33b6acd514bfb9a06a282b2f3b103ead70ce7"
  license "MIT"

  livecheck do
    url "https://packages.sslmate.com/other/"
    regex(/href=.*?sslmate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46c13c2b430a8d3621478a3bd84732bb885f61a11519ac643fce209c72fe17b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46c13c2b430a8d3621478a3bd84732bb885f61a11519ac643fce209c72fe17b1"
    sha256 cellar: :any_skip_relocation, monterey:       "0b9be005d0b52d40b4a8459bf899c891b8a221b177d070fbed649ef42b10a018"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b9be005d0b52d40b4a8459bf899c891b8a221b177d070fbed649ef42b10a018"
    sha256 cellar: :any_skip_relocation, catalina:       "0b9be005d0b52d40b4a8459bf899c891b8a221b177d070fbed649ef42b10a018"
  end

  depends_on "python@3.10"

  uses_from_macos "perl"

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("boto")

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    env = { PERL5LIB: ENV["PERL5LIB"] }
    env[:PYTHONPATH] = ENV["PYTHONPATH"]
    bin.env_script_all_files(libexec/"bin", env)

    rewrite_shebang detected_perl_shebang, libexec/"bin/sslmate"
  end

  test do
    system "#{bin}/sslmate", "req", "www.example.com"
    # Make sure well-formed files were generated:
    system "openssl", "rsa", "-in", "www.example.com.key", "-noout"
    system "openssl", "req", "-in", "www.example.com.csr", "-noout"
    # The version command tests the HTTP client:
    system "#{bin}/sslmate", "version"
  end
end
