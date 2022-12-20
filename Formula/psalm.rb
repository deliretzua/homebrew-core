class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.4.0/psalm.phar"
  sha256 "7798dfebcb3e2e9a540f011141aaabfabcbc2fe666a1bf15c1eb58910faf2148"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a338164ea78cc5e1333f7648f2bbca2da9a2006dd5c4e439395d9c59e177405"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a338164ea78cc5e1333f7648f2bbca2da9a2006dd5c4e439395d9c59e177405"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a338164ea78cc5e1333f7648f2bbca2da9a2006dd5c4e439395d9c59e177405"
    sha256 cellar: :any_skip_relocation, ventura:        "0c77411546db09b54cc17f38978a3ad4de57044d6ada4585b5b6cdc3aa33a55b"
    sha256 cellar: :any_skip_relocation, monterey:       "0c77411546db09b54cc17f38978a3ad4de57044d6ada4585b5b6cdc3aa33a55b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c77411546db09b54cc17f38978a3ad4de57044d6ada4585b5b6cdc3aa33a55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a338164ea78cc5e1333f7648f2bbca2da9a2006dd5c4e439395d9c59e177405"
  end

  depends_on "composer" => :test
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "psalm.phar" => "psalm"
  end

  test do
    (testpath/"composer.json").write <<~EOS
      {
        "name": "homebrew/psalm-test",
        "description": "Testing if Psalm has been installed properly.",
        "type": "project",
        "require": {
          "php": ">=7.1.3"
        },
        "license": "MIT",
        "autoload": {
          "psr-4": {
            "Homebrew\\\\PsalmTest\\\\": "src/"
          }
        },
        "minimum-stability": "stable"
      }
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
      declare(strict_types=1);

      namespace Homebrew\\PsalmTest;

      final class Email
      {
        private string $email;

        private function __construct(string $email)
        {
          $this->ensureIsValidEmail($email);

          $this->email = $email;
        }

        public static function fromString(string $email): self
        {
          return new self($email);
        }

        public function __toString(): string
        {
          return $this->email;
        }

        private function ensureIsValidEmail(string $email): void
        {
          if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new \\InvalidArgumentException(
              sprintf(
                '"%s" is not a valid email address',
                $email
              )
            );
          }
        }
      }
    EOS

    system "composer", "install"

    assert_match "Config file created successfully. Please re-run psalm.",
                 shell_output("#{bin}/psalm --init")
    assert_match "No errors found!",
                 shell_output("#{bin}/psalm")
  end
end
