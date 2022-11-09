class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/ec/3c/e3b7669ac3821562221590611ec3285b736f538290328757e49986977a2b/dtrx-8.4.0.tar.gz"
  sha256 "e96b87194481a54807763b33fc764d4de5fe0e4df6ee51147f72c0ccb3bed6fa"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2582a177447c377d0834cda060ed0b91c3031a7662b5fb39416d14b4266552cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca904570afae2070e6ed146486ceeb736a1cb0793ba5e86b36189c57c7e4855d"
    sha256 cellar: :any_skip_relocation, monterey:       "dd72789077a0d69739d15841bb315bd7f35b901453e782cdb37c277b121a9a2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e2d6b67f690d8eca9a1f2ba57acb9a812043acff3213f670202010906d28cb3"
    sha256 cellar: :any_skip_relocation, catalina:       "81e5b5c1246ddb9a31bc7581c6d4a4dacb4b08e790840a9c8a2823f9682bf5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0994d2a789439bce93d5e4c9460c9f37aaaefd90fcd849d9f9bfc55d974dbdbe"
  end

  # Include a few common decompression handlers in addition to the python dep
  depends_on "p7zip"
  depends_on "python@3.11"
  depends_on "xz"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "unzip"

  def install
    virtualenv_install_with_resources
  end

  # Test a simple unzip. Sample taken from unzip formula
  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    system "zip", "test.zip", "test1", "test2", "test3"
    %w[test1 test2 test3].each do |f|
      rm f
      refute_predicate testpath/f, :exist?, "Text files should have been removed!"
    end

    system "#{bin}/dtrx", "--flat", "test.zip"

    %w[test1 test2 test3].each do |f|
      assert_predicate testpath/f, :exist?, "Failure unzipping test.zip!"
    end

    assert_equal "Hello!", (testpath/"test1").read
    assert_equal "Bonjour!", (testpath/"test2").read
    assert_equal "Hej!", (testpath/"test3").read
  end
end
