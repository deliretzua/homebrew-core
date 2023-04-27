class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.196.tar.gz"
  sha256 "044424a335805a0d10a0b16fe401cdad9962b468829225117b298c5880b623a6"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38383c0c62cde8c4b8ee675c1eeba3587ee25f343c85a97c4cd21233f7ee0546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19155a76d207184c2194bb3e567675228327c5d9631c1baf4ce1ff7897fb6749"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21a486d51b33e5cfd8b14c58978c2a758ab258e4ef8b90423b2814a0be5c4742"
    sha256 cellar: :any_skip_relocation, ventura:        "17d4e279e748e465b318d4e3af94fb3afc764907d0dbf8486beff107cce4fdcd"
    sha256 cellar: :any_skip_relocation, monterey:       "cdc6abea6c966b1c623759e3f3326c37f8586820e189df937f6fc1851ff9ae29"
    sha256 cellar: :any_skip_relocation, big_sur:        "87966590dcb92e0af9cf5419f71c327634bfeeae18cf2c9e9bebcce0bc89879f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a069222284223ebbfc25c29794f2b39d0f628f8d97f48005e1c1e1401e40f1"
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
