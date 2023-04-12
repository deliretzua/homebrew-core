class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.12/phpstan.phar"
  sha256 "34fdb1337995a7d54c2204d2f686767b46d91f53076f945e4dccf5002ae24cb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1e3244ebf993ddb1d795a1ff25017d20bf1e6b218f53dd6b02f6319e7b9c199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1e3244ebf993ddb1d795a1ff25017d20bf1e6b218f53dd6b02f6319e7b9c199"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1e3244ebf993ddb1d795a1ff25017d20bf1e6b218f53dd6b02f6319e7b9c199"
    sha256 cellar: :any_skip_relocation, ventura:        "a072b00dd5fdab3ace94b05788c0acd5cf47cfbcb97604e12f553f8180215ebd"
    sha256 cellar: :any_skip_relocation, monterey:       "a072b00dd5fdab3ace94b05788c0acd5cf47cfbcb97604e12f553f8180215ebd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a072b00dd5fdab3ace94b05788c0acd5cf47cfbcb97604e12f553f8180215ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1e3244ebf993ddb1d795a1ff25017d20bf1e6b218f53dd6b02f6319e7b9c199"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

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
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
