class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.20.tar.gz"
  sha256 "5a6245b5f911b8e5f9b3e93cf298f7c126348e06c7205d68256958651d8c7052"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d3233f17f516a1d523c7fcc85db12a74cda115ead94aa856cc02521206dfad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0e69be0354f059ec49771fd61a6d33fa8aecaafd3f0abfe5ccfe87f12fc0439"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8652569a42abbbd1f3f8586f3b40baca7cc6568f57d69315bc1be9743c52f49"
    sha256 cellar: :any_skip_relocation, ventura:        "e48fd75e7a4314ad24ad86e116ccdca5f02032363b980020fa537dfb603d5496"
    sha256 cellar: :any_skip_relocation, monterey:       "41f9b53e1793e87f7521bf73b8348373ed56dfd61cecbaadc444abe93e39cff4"
    sha256 cellar: :any_skip_relocation, big_sur:        "52f29376dd25f8350c8030f544dcc22c2254e60dc5e0367e08dc63624624f8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3f922c58f1f1b15d47b7cd13399f8c6fd7a85e727bdaca97ec8f6680c0ea4f"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
