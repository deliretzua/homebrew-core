class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.21.1/php-cs-fixer.phar"
  sha256 "7ff843da2b7f976856195a085d00496030bbb3b24f484fbb4736e975e34d46f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cff16f54e46758c4c10765757985279b1d4077cfb262917daef71dd9dbba6089"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cff16f54e46758c4c10765757985279b1d4077cfb262917daef71dd9dbba6089"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cff16f54e46758c4c10765757985279b1d4077cfb262917daef71dd9dbba6089"
    sha256 cellar: :any_skip_relocation, ventura:        "cff16f54e46758c4c10765757985279b1d4077cfb262917daef71dd9dbba6089"
    sha256 cellar: :any_skip_relocation, monterey:       "cff16f54e46758c4c10765757985279b1d4077cfb262917daef71dd9dbba6089"
    sha256 cellar: :any_skip_relocation, big_sur:        "cff16f54e46758c4c10765757985279b1d4077cfb262917daef71dd9dbba6089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca96186022810abb41237b6fbc61b0490c4880acafe4387091d7019513059c5f"
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
