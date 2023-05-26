class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.227.tar.gz"
  sha256 "9120424e6bd187ec1527589540840b43913f1f0416f0dc75820556e11787d3cc"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48e3fb037b4c80c49d96f88db1512feadb18e2aa4028d775225a923e3331906e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eee566046aa79814686045a1aa8da5a8891815d0f4bc2e3f33beb6ef85ca849"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0a42caa5568a6c64658058294a58397ff4b9f0e7da165e17b2391a64b1040c7"
    sha256 cellar: :any_skip_relocation, ventura:        "96eca4269b87a319596e30e451797e2b3a7055dbef3d263f0b6ad4722231a8a5"
    sha256 cellar: :any_skip_relocation, monterey:       "39c9b96b189977e09f90f6d4a7fc1790fb7f3c2cb7a485c67cccfd0b47cc4bce"
    sha256 cellar: :any_skip_relocation, big_sur:        "e41ace4b2ba69a0e9765b6b67823aa62d06dbfb3b61f1e7e9245c3a73d4aa142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dac849666a0e1423bccd247c803de771e64b9d9fd0453f1e1c38f568c30e77b"
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
