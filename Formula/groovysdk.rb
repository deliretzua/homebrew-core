class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.8.zip"
  sha256 "984724105d973b56d83dbfa39ad4fb114abc79e5c92ddf62c802156e684d6906"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c9c6913a0eb3436113dd5cd33b982719a71295b2c67b254e97eed4796a7dfca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c9c6913a0eb3436113dd5cd33b982719a71295b2c67b254e97eed4796a7dfca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c9c6913a0eb3436113dd5cd33b982719a71295b2c67b254e97eed4796a7dfca"
    sha256 cellar: :any_skip_relocation, ventura:        "d0f1216fcc6de05a7b03463f940549c1899af926b9f5bf3a3caa580e0d76346e"
    sha256 cellar: :any_skip_relocation, monterey:       "d0f1216fcc6de05a7b03463f940549c1899af926b9f5bf3a3caa580e0d76346e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0f1216fcc6de05a7b03463f940549c1899af926b9f5bf3a3caa580e0d76346e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c9c6913a0eb3436113dd5cd33b982719a71295b2c67b254e97eed4796a7dfca"
  end

  depends_on "openjdk"

  conflicts_with "groovy", because: "both install the same binaries"

  def install
    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files libexec/"bin",
                             GROOVY_HOME: libexec,
                             JAVA_HOME:   "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
