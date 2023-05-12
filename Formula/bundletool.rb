class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://github.com/google/bundletool/releases/download/1.15.0/bundletool-all-1.15.0.jar"
  sha256 "14e7b268e175c1a832d1695a1cf46c5c7e06949093e6efb7a83c64d7a252f7f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6507a950951ddc371137d1a34a55be2569fd3ded57c3383b9e03bd038dc799a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6507a950951ddc371137d1a34a55be2569fd3ded57c3383b9e03bd038dc799a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6507a950951ddc371137d1a34a55be2569fd3ded57c3383b9e03bd038dc799a2"
    sha256 cellar: :any_skip_relocation, ventura:        "6507a950951ddc371137d1a34a55be2569fd3ded57c3383b9e03bd038dc799a2"
    sha256 cellar: :any_skip_relocation, monterey:       "6507a950951ddc371137d1a34a55be2569fd3ded57c3383b9e03bd038dc799a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6507a950951ddc371137d1a34a55be2569fd3ded57c3383b9e03bd038dc799a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6584f0e5f4cdba5138c57610c732f18861f3b5a0661b26c2e6416201d17033e7"
  end

  depends_on "openjdk"

  resource "homebrew-test-bundle" do
    url "https://github.com/thuongleit/crashlytics-sample/raw/master/app/release/app.aab"
    sha256 "f7ea5a75ce10e394a547d0c46115b62a2f03380a18b1fc222e98928d1448775f"
  end

  def install
    libexec.install "bundletool-all-#{version}.jar" => "bundletool-all.jar"
    bin.write_jar_script libexec/"bundletool-all.jar", "bundletool"
  end

  test do
    resource("homebrew-test-bundle").stage do
      expected = <<~EOS
        App Bundle information
        ------------
        Feature modules:
        \tFeature module: base
        \t\tFile: res/anim/abc_fade_in.xml
      EOS

      assert_match expected, shell_output("#{bin}/bundletool validate --bundle app.aab")
    end
  end
end
