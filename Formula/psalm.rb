class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.7.4/psalm.phar"
  sha256 "09ebc4dbb0d5cb97ab5a755c4d617902b83ebd6963b8d34111587a8c945f0e9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7ff81ec51ffd09d0e184ac3040056b951658df3a68806839df58786855505b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ff81ec51ffd09d0e184ac3040056b951658df3a68806839df58786855505b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7ff81ec51ffd09d0e184ac3040056b951658df3a68806839df58786855505b5"
    sha256 cellar: :any_skip_relocation, ventura:        "323cf4c972b1c1d68a08e4d335bed9b3fa4f2544b8cab7a72dd40d95821f4140"
    sha256 cellar: :any_skip_relocation, monterey:       "323cf4c972b1c1d68a08e4d335bed9b3fa4f2544b8cab7a72dd40d95821f4140"
    sha256 cellar: :any_skip_relocation, big_sur:        "323cf4c972b1c1d68a08e4d335bed9b3fa4f2544b8cab7a72dd40d95821f4140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ff81ec51ffd09d0e184ac3040056b951658df3a68806839df58786855505b5"
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
