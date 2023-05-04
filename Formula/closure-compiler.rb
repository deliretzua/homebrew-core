class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://developers.google.com/closure/compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20230502/closure-compiler-v20230502.jar"
  sha256 "87f90a557e3d2ae8af430ac6f4a42becf1b453485e890999777a52c90bda9d22"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/"
    regex(/href=.*?v?(\d{8})/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74fef15bfb9a587731a44551611685d448d6bca7d1443172600780ffa2e4f77f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74fef15bfb9a587731a44551611685d448d6bca7d1443172600780ffa2e4f77f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74fef15bfb9a587731a44551611685d448d6bca7d1443172600780ffa2e4f77f"
    sha256 cellar: :any_skip_relocation, ventura:        "74fef15bfb9a587731a44551611685d448d6bca7d1443172600780ffa2e4f77f"
    sha256 cellar: :any_skip_relocation, monterey:       "74fef15bfb9a587731a44551611685d448d6bca7d1443172600780ffa2e4f77f"
    sha256 cellar: :any_skip_relocation, big_sur:        "74fef15bfb9a587731a44551611685d448d6bca7d1443172600780ffa2e4f77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66b8cd30f5c1c8750fe89da50eeec0f6d239ceded9efa94a46bb1b230032dc9"
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
