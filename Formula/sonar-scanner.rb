class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/"
  url "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.0.2966.zip"
  sha256 "1552987ca036d85b83ba68b815d641e26df04afff02570c6b72bec0fe4adea37"
  license "LGPL-3.0-or-later"
  head "https://github.com/SonarSource/sonar-scanner-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2afdbf58216d9c6e1dc8138fbaae51ac5945bc9e86f8520d70acf710df97e536"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install libexec/"bin/sonar-scanner"
    etc.install libexec/"conf/sonar-scanner.properties"
    ln_s etc/"sonar-scanner.properties", libexec/"conf/sonar-scanner.properties"
    bin.env_script_all_files libexec/"bin/",
                              SONAR_SCANNER_HOME: libexec,
                              JAVA_HOME:          Formula["openjdk"].opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end
