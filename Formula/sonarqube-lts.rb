class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.8.0.63668.zip"
  sha256 "5898eea6176e777b2af5656618cf679d235cb895c383c2cbd0b7bbf852d0f632"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarqube.org/downloads/"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LTS.*?href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.(?:zip|t)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d1b2925ff6de9bc8b576a4e5ccc1b701022e019e517f9bfafffc75231c1486c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d1b2925ff6de9bc8b576a4e5ccc1b701022e019e517f9bfafffc75231c1486c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d1b2925ff6de9bc8b576a4e5ccc1b701022e019e517f9bfafffc75231c1486c"
    sha256 cellar: :any_skip_relocation, ventura:        "6d1b2925ff6de9bc8b576a4e5ccc1b701022e019e517f9bfafffc75231c1486c"
    sha256 cellar: :any_skip_relocation, monterey:       "6d1b2925ff6de9bc8b576a4e5ccc1b701022e019e517f9bfafffc75231c1486c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d1b2925ff6de9bc8b576a4e5ccc1b701022e019e517f9bfafffc75231c1486c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6b227ed1295286bb2db862ba96f2f4603a2e9d2fe492b426e109be289af3a34"
  end

  depends_on "openjdk@17"

  conflicts_with "sonarqube", because: "both install the same binaries"

  def install
    # Delete native bin directories for other systems
    remove, keep = if OS.mac?
      ["linux", "macosx-universal"]
    else
      ["macosx", "linux-x86"]
    end

    rm_rf Dir["bin/{#{remove},windows}-*"]

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/#{keep}-64/sonar.sh",
      Language::Java.overridable_java_home_env("17")
  end

  service do
    run [opt_bin/"sonar", "start"]
  end

  test do
    ENV["SONAR_JAVA_PATH"] = Formula["openjdk@17"].opt_bin/"java"
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
