class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v5.1.0/epubcheck-5.1.0.zip"
  sha256 "74a59af8602bf59b1d04266a450d9cdcb5986e36d825adc403cde0d95e88c9e8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6115d50769b1fcefd4ea30fcd097eefdc426da30165a3c377c5210d0555bc802"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
