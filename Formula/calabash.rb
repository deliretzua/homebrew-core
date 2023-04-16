class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.5.4-120/xmlcalabash-1.5.4-120.zip"
  sha256 "f50d132d0c55a363fdcb4e7541d77558d700e8235853908f2925d45ad55c4334"
  license any_of: ["GPL-2.0-only", "CDDL-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a94df53dffca513f8708a4c8ece8fc520eb431a30c15af964d46f7385d2cf4b5"
  end

  depends_on "openjdk"
  depends_on "saxon"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"xmlcalabash-#{version}.jar", "calabash", "-Xmx1024m"
  end

  test do
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "#{bin}/calabash", "#{libexec}/xpl/pipe.xpl"
  end
end
