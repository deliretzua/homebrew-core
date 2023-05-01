class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "cd80872d6972cb495df178f4290b29abdc6d7bb22a8de788509884180dc21545"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99ece2b43fe34b3fbb15450faf7d1903e50b66118c31255dcd6f3e477f5dac6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a32c3fb7608927752c2e8c4d874be0904dd1bd3867a73fba9fe2598322b4b4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4802b1ea209fcd7048fc495bc8de21edd89414e342810d0ef016ba5249d1a0e"
    sha256 cellar: :any_skip_relocation, ventura:        "fd2552f1eac76c7de6ae13836df8f9aa67ad4908b1eea40cc0a4ad1651eef248"
    sha256 cellar: :any_skip_relocation, monterey:       "ba4101686d7ebcbd8a063fe884428dee16f0d9ede495c17242d32961e37a6a3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "572beb31bf6fd40b8126a5b66490409bd41a508d29aba6822977656a0ef45810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12cd70df06f54ed6b3526f27d29e750651ffe9cfe45ff3e385d6ed56f8e5970a"
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
