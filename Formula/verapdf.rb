class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.187.tar.gz"
  sha256 "53bdab8ce1610839a301865e6498314e66fe491aaeb89c00201284cbb2883050"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "222169fae4f6e09cace71e14cb1e40233750131d5915423028af33f02b7ec9eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caac000f6d1df3f26499daf6255965128737b7ee9a73e93ac2709a1747eb2635"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed4508e3fcdf01d0180d7e3e78dca025c08b1ff55a74084074b3df80a1b783a4"
    sha256 cellar: :any_skip_relocation, ventura:        "9192fc8086a94a72bb44b914a20df62d3b91da6e2703faee1e73a0f18495461c"
    sha256 cellar: :any_skip_relocation, monterey:       "08545e3fa590ebb3e869efb94f0c792d651228139d56d3a9457946a67fb453d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec5aadec81bb938c8b16f09148c35badc1208c0d873bd6d6b54e686c36362483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640747a96361be3b704c5c2bf31357cf8466e49ce01cab3afe7cd846341010a3"
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
