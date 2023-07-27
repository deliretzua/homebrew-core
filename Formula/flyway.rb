class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/9.21.1/flyway-commandline-9.21.1.tar.gz"
  sha256 "a5b64daa57b81312c6a08089ba627de0f6272f6d9bc597c774ccd66e8dcfe0d5"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b989771792205d771b712ea490f8b0a6b619929642bb62c349fb92485f7992f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b989771792205d771b712ea490f8b0a6b619929642bb62c349fb92485f7992f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b989771792205d771b712ea490f8b0a6b619929642bb62c349fb92485f7992f7"
    sha256 cellar: :any_skip_relocation, ventura:        "b989771792205d771b712ea490f8b0a6b619929642bb62c349fb92485f7992f7"
    sha256 cellar: :any_skip_relocation, monterey:       "b989771792205d771b712ea490f8b0a6b619929642bb62c349fb92485f7992f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b989771792205d771b712ea490f8b0a6b619929642bb62c349fb92485f7992f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c8f7832e712bfb84ee504d93c0ff1157cdfa4e9309dc2f703aeb86dc85332fc"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
