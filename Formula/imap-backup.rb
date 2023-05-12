class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v9.3.1.tar.gz"
  sha256 "64785003142d6a52be15c6cbc9ed93c89a27435821f3352b8ffc0cbb96c63f09"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24528d9de41731417194bcca019d57f9e5cade299eefbf64949a5e9ffaedd7dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24528d9de41731417194bcca019d57f9e5cade299eefbf64949a5e9ffaedd7dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24528d9de41731417194bcca019d57f9e5cade299eefbf64949a5e9ffaedd7dd"
    sha256 cellar: :any_skip_relocation, ventura:        "24528d9de41731417194bcca019d57f9e5cade299eefbf64949a5e9ffaedd7dd"
    sha256 cellar: :any_skip_relocation, monterey:       "24528d9de41731417194bcca019d57f9e5cade299eefbf64949a5e9ffaedd7dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "24528d9de41731417194bcca019d57f9e5cade299eefbf64949a5e9ffaedd7dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d25e5c32951604c015d025ae76dd4f2d6009028d3ee2f64b25c7fb888bfbb18"
  end

  uses_from_macos "ruby", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Choose an action:", pipe_output(bin/"imap-backup setup", "3\n")
  end
end
