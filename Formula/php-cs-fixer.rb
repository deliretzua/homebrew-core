class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.21.2/php-cs-fixer.phar"
  sha256 "4dc7450fbc6fc885b982ec745eed026145c5c6b441ed949af740579fc5f49c80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dedfbe56ae6f95b38f04adcc29fc4f715965324b9f0d3b44241a1cf50a6dce88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dedfbe56ae6f95b38f04adcc29fc4f715965324b9f0d3b44241a1cf50a6dce88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dedfbe56ae6f95b38f04adcc29fc4f715965324b9f0d3b44241a1cf50a6dce88"
    sha256 cellar: :any_skip_relocation, ventura:        "dedfbe56ae6f95b38f04adcc29fc4f715965324b9f0d3b44241a1cf50a6dce88"
    sha256 cellar: :any_skip_relocation, monterey:       "dedfbe56ae6f95b38f04adcc29fc4f715965324b9f0d3b44241a1cf50a6dce88"
    sha256 cellar: :any_skip_relocation, big_sur:        "dedfbe56ae6f95b38f04adcc29fc4f715965324b9f0d3b44241a1cf50a6dce88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d821c93cbecf5bd358d5f2d47451520285b04692399558f034c9646c143da454"
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
