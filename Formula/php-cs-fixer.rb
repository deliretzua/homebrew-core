class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.22.0/php-cs-fixer.phar"
  sha256 "88fe5d98991867f1354c09b8a0b382090e4309ce3e23709c12bf2d39ecf30ade"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c42c4a2839dfe2f1485b0e9dab2588ce48202a186408b4424d56b3810f56dba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c42c4a2839dfe2f1485b0e9dab2588ce48202a186408b4424d56b3810f56dba6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c42c4a2839dfe2f1485b0e9dab2588ce48202a186408b4424d56b3810f56dba6"
    sha256 cellar: :any_skip_relocation, ventura:        "c42c4a2839dfe2f1485b0e9dab2588ce48202a186408b4424d56b3810f56dba6"
    sha256 cellar: :any_skip_relocation, monterey:       "c42c4a2839dfe2f1485b0e9dab2588ce48202a186408b4424d56b3810f56dba6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c42c4a2839dfe2f1485b0e9dab2588ce48202a186408b4424d56b3810f56dba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "525a448f0c1376c0cba02ebbbd12504084b8a7c3168105c01b2dba677462c65d"
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
