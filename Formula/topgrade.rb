class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.1.2.tar.gz"
  sha256 "978d6cf2c5d6ab71fe21960a98c27050c3ead132f322dd268abc287185dbef60"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eac5da4a5438a8a0b9300a70f02a7fc9a243a81ad25dee9b54aa055ea588e77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cb32a6ec7aa2d82f81d6e0c483e1455dccaa5d56382761f83c2fc609b73a653"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fd1243a5d02d95086f1aee9eb54ca6f17fd2f9017e2251b186097e88cdad067"
    sha256 cellar: :any_skip_relocation, monterey:       "d8437474c1e54899c01a9cdac55c59df44d40610975815d4d8b0ed4f1b73c4c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "388b3b209e2c6163b2200b192ea5140ca4ecd441ad448c5e84cb912ac012b0c6"
    sha256 cellar: :any_skip_relocation, catalina:       "e5860bab77192e878c883a844a8a9a23e7d7c9ef32ebf1f4dd8761cd470fd46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c97260725bede3a7fda6e20ca7a139c2be589fdbfcdd3c71ebbeade008e12ed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuration path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
