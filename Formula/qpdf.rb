class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.2.0/qpdf-10.2.0.tar.gz"
  sha256 "43ef260f4e70672660e1882856d59b9319301c6f170673ab465430a71cffe44c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c67009187b297a88ae00a45983b27ca082e2907db1618ce864452a69ef683f63"
    sha256 cellar: :any, big_sur:       "c857f3f740bba6770c759b6a4bbb1c805ec333e3f96cdf75ff0100c8365196b5"
    sha256 cellar: :any, catalina:      "5a6208cd3267fbec41837612b535f558f383e16f67dcb7a78c8ef5808cffda5c"
    sha256 cellar: :any, mojave:        "5f1da4c5b3f8bcd4b308ff0ed6941d8faa708cb3b06b13faee860c4f72650c3b"
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
