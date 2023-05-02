class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.203.tar.gz"
  sha256 "5e710e8b860af00c5da5ddc22cd537d650bbc4905a6c0dd091def0174eeaeaf2"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7b06a669d51b7b7ff421a019023769ae8a566ce0ad1dcb147958a58148d68c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a34d063681ff2220b28015d63c49542c99051ddc08c2d1b30aeab10d248624ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5e934a442c8c1cc8d7c9c690b1dcc46be051172f5c6f5619f56bb9088aad1fa"
    sha256 cellar: :any_skip_relocation, ventura:        "bb08d29593be72f5ba380c1a48b878cc1958bacf8df4859a5fa96dcb173f941c"
    sha256 cellar: :any_skip_relocation, monterey:       "4962bac2e26371b90b1ca8e2ccc21c7c1c36c7179daf3b37f204cebf55e1cbd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b51203a472bf1758e563c45991437e1ca683ebd26241ba1e10aa4c7150ad88f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e143b3ab2bdbe0c56d718ddba6cf8b4667df271e22779f317ba53fe06455bbc3"
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
