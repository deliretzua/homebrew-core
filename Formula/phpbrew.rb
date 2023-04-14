class Phpbrew < Formula
  desc "Brew & manage PHP versions in pure PHP at HOME"
  homepage "https://phpbrew.github.io/phpbrew"
  url "https://github.com/phpbrew/phpbrew/releases/download/2.1.0/phpbrew.phar"
  sha256 "0f8f55bb31f6680ad3b9703cddb46d9c5186ea67778fc1896b35f44569d9d006"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03a4ce471cc9c831a38897771691b9e1089210951a6ad6e2722dfb8aa4ffa716"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a4ce471cc9c831a38897771691b9e1089210951a6ad6e2722dfb8aa4ffa716"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03a4ce471cc9c831a38897771691b9e1089210951a6ad6e2722dfb8aa4ffa716"
    sha256 cellar: :any_skip_relocation, ventura:        "5782ecc05e283e4a773cfcdc5d9048e82a85d00f7ceb6a598c2f96e7ae6f0592"
    sha256 cellar: :any_skip_relocation, monterey:       "5782ecc05e283e4a773cfcdc5d9048e82a85d00f7ceb6a598c2f96e7ae6f0592"
    sha256 cellar: :any_skip_relocation, big_sur:        "5782ecc05e283e4a773cfcdc5d9048e82a85d00f7ceb6a598c2f96e7ae6f0592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a4ce471cc9c831a38897771691b9e1089210951a6ad6e2722dfb8aa4ffa716"
  end

  # TODO: When `php` 8.2+ support is landed, switch back to `php`.
  # https://github.com/phpbrew/phpbrew/blob/#{version}/composer.json#L27
  depends_on "php@8.1"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    # When switched back to `php`, use `bin.install` instead.
    # bin.install "phpbrew.phar" => "phpbrew"

    libexec.install "phpbrew.phar"
    (bin/"phpbrew").write <<~EOS
      #!#{Formula["php@8.1"].opt_bin}/php
      <?php require '#{libexec}/phpbrew.phar';
    EOS
  end

  test do
    system bin/"phpbrew", "init"
    assert_match "8.0", shell_output("#{bin}/phpbrew known")
  end
end
