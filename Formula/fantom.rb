class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "https://fantom.org/"
  url "https://github.com/fantom-lang/fantom/releases/download/v1.0.79/fantom-1.0.79.zip"
  sha256 "d70d706b55b65c2e9abd8c970448b4e7bd28d1243724dbdea9d0f3c0fa8d5e4c"
  license "AFL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fcc2fc9b9274107bebe956c165da541fbbd1171b954d21c426e3d7cb4542ca8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fcc2fc9b9274107bebe956c165da541fbbd1171b954d21c426e3d7cb4542ca8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fcc2fc9b9274107bebe956c165da541fbbd1171b954d21c426e3d7cb4542ca8"
    sha256 cellar: :any_skip_relocation, ventura:        "0ba7cd9d14d193ac7a20703e8ed5e1fba69ec4d0856daa7860892be4d1410f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "0ba7cd9d14d193ac7a20703e8ed5e1fba69ec4d0856daa7860892be4d1410f6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ba7cd9d14d193ac7a20703e8ed5e1fba69ec4d0856daa7860892be4d1410f6d"
    sha256 cellar: :any_skip_relocation, catalina:       "0ba7cd9d14d193ac7a20703e8ed5e1fba69ec4d0856daa7860892be4d1410f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fcc2fc9b9274107bebe956c165da541fbbd1171b954d21c426e3d7cb4542ca8"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.exe", "bin/*.dll", "lib/dotnet/*"]

    # Select OpenJDK path in the config file
    java_home = Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"
    inreplace "etc/build/config.props", %r{//jdkHome=/System.*$}, "jdkHome=#{java_home}"

    libexec.install Dir["*"]
    chmod 0755, Dir["#{libexec}/bin/*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: java_home
  end

  test do
    (testpath/"test.fan").write <<~EOS
      class ATest {
        static Void main() { echo("a test") }
      }
    EOS

    assert_match "a test", shell_output("#{bin}/fan test.fan").chomp
  end
end
