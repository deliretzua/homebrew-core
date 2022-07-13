class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.8.1/phpstan.phar"
  sha256 "37bd9e4a87868dddb72431eaf03bf0229dce43e69080ba1a31171e6201ce556c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "682c23cadd05db3a640fcfe43a1b3e2f46cebd7e6b3335f9dfada8e99ed8f070"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "682c23cadd05db3a640fcfe43a1b3e2f46cebd7e6b3335f9dfada8e99ed8f070"
    sha256 cellar: :any_skip_relocation, monterey:       "f90a99d4d32be393671cc123588791a5b6c2b980beb319cdb2bb10806fdcabf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f90a99d4d32be393671cc123588791a5b6c2b980beb319cdb2bb10806fdcabf6"
    sha256 cellar: :any_skip_relocation, catalina:       "f90a99d4d32be393671cc123588791a5b6c2b980beb319cdb2bb10806fdcabf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "682c23cadd05db3a640fcfe43a1b3e2f46cebd7e6b3335f9dfada8e99ed8f070"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
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
