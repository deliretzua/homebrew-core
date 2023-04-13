class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://developers.google.com/closure/compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20230411/closure-compiler-v20230411.jar"
  sha256 "8d9dbc6a6e3030de56a78262a91e1496a32253c2119c9d29220c7de1172ed35a"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/"
    regex(/href=.*?v?(\d{8})/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, ventura:        "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, monterey:       "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e113b3243041ff959f785c31e26efb8a6813a6c6e93ff624c74a85afd378f252"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"closure-compiler-v#{version}.jar", "closure-compiler"
  end

  test do
    (testpath/"test.js").write <<~EOS
      (function(){
        var t = true;
        return t;
      })();
    EOS
    system bin/"closure-compiler",
           "--js", testpath/"test.js",
           "--js_output_file", testpath/"out.js"
    assert_equal (testpath/"out.js").read.chomp, "(function(){return!0})();"
  end
end
