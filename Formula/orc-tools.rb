class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.9.0/orc-tools-1.9.0-uber.jar"
  sha256 "26d0f9635b02d2c31229001810d66cc5a92d63f4eb893e5bee9a686011cbf91c"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "097babecb8fd175d89765c66221143da8e05b583fdce62ee20aa595ffae35404"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "097babecb8fd175d89765c66221143da8e05b583fdce62ee20aa595ffae35404"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "097babecb8fd175d89765c66221143da8e05b583fdce62ee20aa595ffae35404"
    sha256 cellar: :any_skip_relocation, ventura:        "097babecb8fd175d89765c66221143da8e05b583fdce62ee20aa595ffae35404"
    sha256 cellar: :any_skip_relocation, monterey:       "097babecb8fd175d89765c66221143da8e05b583fdce62ee20aa595ffae35404"
    sha256 cellar: :any_skip_relocation, big_sur:        "097babecb8fd175d89765c66221143da8e05b583fdce62ee20aa595ffae35404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3abc701d3c8cfd9caa4121c16cae97c105586aa9ca232001da412ab8e58d5e2"
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
