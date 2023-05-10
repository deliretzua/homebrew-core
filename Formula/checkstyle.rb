class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.11.0/checkstyle-10.11.0-all.jar"
  sha256 "170f2c1b78809c55db7731a06c3244a0618675df9d4b10ab4b82932ee9c4ca30"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcd540c8493a5720b5e0cd74a87808a08e46e0a2d3576878f5b0af67d1ba1cc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcd540c8493a5720b5e0cd74a87808a08e46e0a2d3576878f5b0af67d1ba1cc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcd540c8493a5720b5e0cd74a87808a08e46e0a2d3576878f5b0af67d1ba1cc1"
    sha256 cellar: :any_skip_relocation, ventura:        "fcd540c8493a5720b5e0cd74a87808a08e46e0a2d3576878f5b0af67d1ba1cc1"
    sha256 cellar: :any_skip_relocation, monterey:       "fcd540c8493a5720b5e0cd74a87808a08e46e0a2d3576878f5b0af67d1ba1cc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcd540c8493a5720b5e0cd74a87808a08e46e0a2d3576878f5b0af67d1ba1cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c4d65e22f51efd05e0ed88e27fc32fae7f74fd42476872b137fb959e67b8051"
  end

  depends_on "openjdk"

  def install
    libexec.install "checkstyle-#{version}-all.jar"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = shell_output("#{bin}/checkstyle -c /sun_checks.xml #{path}", 2)
    errors = output.lines.select { |line| line.start_with?("[ERROR] #{path}") }
    assert_match "#{path}:1:17: '{' is not preceded with whitespace.", errors.join(" ")
    assert_equal errors.size, $CHILD_STATUS.exitstatus
  end
end
