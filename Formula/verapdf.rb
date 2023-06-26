class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.5.tar.gz"
  sha256 "7503689af40e47cecd45e504f78452d92326a31701b969b663eb12c0027c9db0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64614cdff2bfc92c3589aae90c097b6b7453f729b55ba65d3777edcc73606e7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5340858d716d1c1252bb80fbe574abb0aaa97963bed67dfa22cba0ebd664f6b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f3901ab9481d7d2e460dde967bcb54657101f1c74beb5a22e3f426a9b1ea32a"
    sha256 cellar: :any_skip_relocation, ventura:        "23c683d397d4744fef8c6ffc257a6ff84eb9402edde369492169f5643c451b90"
    sha256 cellar: :any_skip_relocation, monterey:       "1050a7ce0185781b3ed528ff14c1d3fba0cf2f407febce134d3007ec03d1aaa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd56a42070950623d98cab566ea38ca8b994fdffb07bcdd5922c4f68db32e2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e2a5b402c95439a59cffaace8e884d80b2ccd2dae77cdc3436bdb658d342605"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  # fix exit code for parse error, remove when merged and released
  patch do
    url "https://github.com/veraPDF/veraPDF-apps/commit/6cc00fca6b183160b482f7aa1e9e1e90fdec54e9.patch?full_index=1"
    sha256 "67bbe4873b0ae190c97bd29a3fad5d3413b872c4526c480e96272c71a3c15e43"
  end

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
