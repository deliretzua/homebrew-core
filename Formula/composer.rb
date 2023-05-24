class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.5.7/composer.phar"
  sha256 "9256c4c1c803b9d0cb7a66a1ab6c737e48c43cc6df7b8ec9ec2497a724bf44de"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89abdaf4e8b807e2b4c791f7bc7bc86530df3f83cf4bbf3f4a7b9eb3b33a2022"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89abdaf4e8b807e2b4c791f7bc7bc86530df3f83cf4bbf3f4a7b9eb3b33a2022"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89abdaf4e8b807e2b4c791f7bc7bc86530df3f83cf4bbf3f4a7b9eb3b33a2022"
    sha256 cellar: :any_skip_relocation, ventura:        "11c2f894314faee67f9a5a1d8c9ad95af243ab5dd3ef32fd0401ff84f3539de9"
    sha256 cellar: :any_skip_relocation, monterey:       "11c2f894314faee67f9a5a1d8c9ad95af243ab5dd3ef32fd0401ff84f3539de9"
    sha256 cellar: :any_skip_relocation, big_sur:        "11c2f894314faee67f9a5a1d8c9ad95af243ab5dd3ef32fd0401ff84f3539de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89abdaf4e8b807e2b4c791f7bc7bc86530df3f83cf4bbf3f4a7b9eb3b33a2022"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "composer.phar" => "composer"
  end

  test do
    (testpath/"composer.json").write <<~EOS
      {
        "name": "homebrew/test",
        "authors": [
          {
            "name": "Homebrew"
          }
        ],
        "require": {
          "php": ">=5.3.4"
          },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        }
      }
    EOS

    (testpath/"src/HelloWorld/Greetings.php").write <<~EOS
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    EOS

    (testpath/"tests/test.php").write <<~EOS
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    EOS

    system "#{bin}/composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
