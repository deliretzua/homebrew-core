class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.8.4/orc-tools-1.8.4-uber.jar"
  sha256 "da4de22017eb189454c2965242a907c573bbce610c6e62da1dde2e101ed9527e"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f344899ccd86674a3401f5c0413e2835a204175805a68ee92bd4e14c978c5fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f344899ccd86674a3401f5c0413e2835a204175805a68ee92bd4e14c978c5fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f344899ccd86674a3401f5c0413e2835a204175805a68ee92bd4e14c978c5fc"
    sha256 cellar: :any_skip_relocation, ventura:        "6f344899ccd86674a3401f5c0413e2835a204175805a68ee92bd4e14c978c5fc"
    sha256 cellar: :any_skip_relocation, monterey:       "6f344899ccd86674a3401f5c0413e2835a204175805a68ee92bd4e14c978c5fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f344899ccd86674a3401f5c0413e2835a204175805a68ee92bd4e14c978c5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83f1383190fe72f08440fc53f8bedb12be18ab6c005f29fb19c3b7d23dc1fc5d"
  end

  depends_on "openjdk"

  def install
    libexec.install "orc-tools-#{version}-uber.jar"
    bin.write_jar_script libexec/"orc-tools-#{version}-uber.jar", "orc-tools"
  end

  test do
    system "#{bin}/orc-tools", "meta", "-h"
  end
end
