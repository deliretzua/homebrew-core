class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1670.tar.gz"
  sha256 "c70f1b8f6df501d826988ed000f40eec09ff20f6aa6d79f8e22b05748630f3a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "649df0a974742a2232df47eca8a50ed87b866180476af3a96021bc581e779d55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47ed53984c4eb797306f0fb6129d39f1ddd70f8508b2ad6ad760e59d8797d5e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1322c1528531450c5a113c51944115d92ec370f5f8b76282b8200aacec33671e"
    sha256 cellar: :any_skip_relocation, ventura:        "0eb7561bcb936aae6cd2a17ae9fc68fba03a286467c4e7b333ad6eea9f65b011"
    sha256 cellar: :any_skip_relocation, monterey:       "ee055af17f6bbbe173f429ed6cc3dc45cd11ddd769e635cd93b8f387749ad4da"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0d5b4a4122124b2a4d366c3e93e25dfe8c4e1112090ad581d2e3c326680b789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b14088e2d1b2d1a3980cc9569cf49696e66250d71d3b1e889a0d395a8fe29e71"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk@17"
  depends_on "php"

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm_f Dir["**/*.bat"]
      libexec.install Pathname.pwd.children
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env("17")
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    EOS

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_predicate testpath/"cpg.bin", :exist?
  end
end
