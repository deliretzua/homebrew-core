class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.11.0.tar.gz"
  sha256 "86dba70bc6370af9db2e1364c1c97dc57f884703bc6814c7a845ec2bdf1ed279"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f6a927a89bd21da514b23a6e0926195b3975801b1acf804f338e7e2050ee85f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88fb042ee8885cc77b8ccd0a05ee677b6c7c8380022ec537c6315d69d7207f91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eeb64ee7ee58144ec406ccf1ec6e3ebe18bbed47cfe61fdd4ae125c1b279f3e9"
    sha256 cellar: :any_skip_relocation, ventura:        "7d7197d83722d205ed7a7f46851aae1fa3a7767198456e30e3fa0cf1f2fb0c87"
    sha256 cellar: :any_skip_relocation, monterey:       "c2167a462ec989275bfda2794363baf9c3e9827d5f8171ea197d437346a67e74"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecc793e157526f843e6576f6e4798f01e80f08483721a5521b82778f494bfd1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2af492fe81b59ffc2012783fb24bf8dfb2d4c34b3cc001c257e8007595823f44"
  end

  depends_on "openjdk@11"

  # Fix shadowJar build failure, remove in next release
  patch do
    url "https://github.com/int128/groovy-ssh/commit/87913563ebb96c95a9fd17737c56aeff29916f0a.patch?full_index=1"
    sha256 "c4c41e991ebb2eed737fb4bc90667a4b1f00958cabe8c4a5695c855072c7aeaf"
  end

  def install
    ENV["CIRCLE_TAG"] = version
    ENV["VERSION"] = version
    system "./gradlew", "shadowJar"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    assert_match "groovy-ssh-#{version}", shell_output("#{bin}/gssh --version")
  end
end
