class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.1/phpstan.phar"
  sha256 "b146c2bbd3a221c23f0873004f60ecbdd932ea65ca337227b33d3df18acc2aec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe38d5eda7b7a8b979abff4bfd3e970a043ef6ca6671f2154a579a9e942acb27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe38d5eda7b7a8b979abff4bfd3e970a043ef6ca6671f2154a579a9e942acb27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe38d5eda7b7a8b979abff4bfd3e970a043ef6ca6671f2154a579a9e942acb27"
    sha256 cellar: :any_skip_relocation, ventura:        "1d6886841e332d9c847ccffbb6bdadeb2ae5d75d47c90a81aea3f1634208aef8"
    sha256 cellar: :any_skip_relocation, monterey:       "1d6886841e332d9c847ccffbb6bdadeb2ae5d75d47c90a81aea3f1634208aef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d6886841e332d9c847ccffbb6bdadeb2ae5d75d47c90a81aea3f1634208aef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe38d5eda7b7a8b979abff4bfd3e970a043ef6ca6671f2154a579a9e942acb27"
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
