class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.17.0/php-cs-fixer.phar"
  sha256 "ae3a832028cc19498ef35953380dac8c8bd8a42ee45fcc86be727fefab7839f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e205f5eb7fc4f155b5521e1d1ff5e41d5aebc1af9e86bb602a6fbeef1cc1910d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e205f5eb7fc4f155b5521e1d1ff5e41d5aebc1af9e86bb602a6fbeef1cc1910d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e205f5eb7fc4f155b5521e1d1ff5e41d5aebc1af9e86bb602a6fbeef1cc1910d"
    sha256 cellar: :any_skip_relocation, ventura:        "e205f5eb7fc4f155b5521e1d1ff5e41d5aebc1af9e86bb602a6fbeef1cc1910d"
    sha256 cellar: :any_skip_relocation, monterey:       "e205f5eb7fc4f155b5521e1d1ff5e41d5aebc1af9e86bb602a6fbeef1cc1910d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e205f5eb7fc4f155b5521e1d1ff5e41d5aebc1af9e86bb602a6fbeef1cc1910d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a445e663601751bd92b49e23045b4ccb2a6964b769c1141970cee5d4bb60edc"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
