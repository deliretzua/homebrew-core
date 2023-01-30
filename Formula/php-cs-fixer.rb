class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  # Bump to php 8.2 on the next release, if possible.
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.14.2/php-cs-fixer.phar"
  sha256 "8ec2bb81013b700c0586fd6a35e7f33f492f142c93fe7f8d7d3875d71328b395"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deae318186a71f7c9474326dc69a46c3db5c9fb12899ce41afd90a45cf49208a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deae318186a71f7c9474326dc69a46c3db5c9fb12899ce41afd90a45cf49208a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "deae318186a71f7c9474326dc69a46c3db5c9fb12899ce41afd90a45cf49208a"
    sha256 cellar: :any_skip_relocation, ventura:        "deae318186a71f7c9474326dc69a46c3db5c9fb12899ce41afd90a45cf49208a"
    sha256 cellar: :any_skip_relocation, monterey:       "deae318186a71f7c9474326dc69a46c3db5c9fb12899ce41afd90a45cf49208a"
    sha256 cellar: :any_skip_relocation, big_sur:        "deae318186a71f7c9474326dc69a46c3db5c9fb12899ce41afd90a45cf49208a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c2d2ff84570217bf8863ae979a6cdee51279e736a564808d805f85c0513315c"
  end

  depends_on "php@8.1"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php@8.1"].opt_bin}/php
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

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
