class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.163.tar.gz"
  sha256 "eac3001660e4bb1e36a7f59a828f6887de4dfb436a1230b467331ffd5aaa650e"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e69e124a2b2f38484d69b1512a29a18ecddbcb571bdccfa61a6fa0dca1977f20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13020cada6abe151cbc3f9aee31623a6bdc214e93061da2fe2b5cd9f4833933b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "610999b9175e06aa5ce2091181fddf0d2cf204e2b4af72f260e1e7457a07c20e"
    sha256 cellar: :any_skip_relocation, ventura:        "9ce97971338f9d4a58aea8a23298db9e53b096ee9f047c1a278b2fd6987d0a82"
    sha256 cellar: :any_skip_relocation, monterey:       "9096079767679718cb87df3f406cded14a80028eb95d9ff52768b214c16ed5d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "522ea4986fafa8ce545a78fc02fea368a238582a6cb60512cb255b5c0b07e6bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bb4f688f7e9b516c7143888e9a1ec7626e8ffed7ee548f7a5e75102a97d8093"
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
