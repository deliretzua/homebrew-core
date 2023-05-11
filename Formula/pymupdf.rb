class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/3e/06/bd008c25b210a13b8f7684d880fb7ae098d8bbbecabd6547932650a61fa0/PyMuPDF-1.22.3.tar.gz"
  sha256 "5ecd928e96e63092571020973aa145b57b75707f3a3df97c742e563112615891"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2cd7daf01a6300b08f67918173ec0f34e2fb94f97ac69ec30cb7db2d41f212a"
    sha256 cellar: :any,                 arm64_monterey: "562b328e760185a632d00c0d0d8a4cf26a6f1d80ccf285e79d92fca506052d03"
    sha256 cellar: :any,                 arm64_big_sur:  "1a1db7c33d70248cfa3b6374000d2fdbed22a8aa7bf63e91addc09fe65c9a416"
    sha256 cellar: :any,                 ventura:        "452646c94ea804ddbf9e0ad30d4d613940a5d83601bc4d77caad604f3b0ebba3"
    sha256 cellar: :any,                 monterey:       "cfc9b3da10fb695d90d519f4da263a43a69842cc3f142175fca38fbdfb498740"
    sha256 cellar: :any,                 big_sur:        "c25c41efb545f69f6cd1789105e5ec491699ed707ef9a13f0ad2d26416518420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43224782dc88424f1d444374583e10b990579fd27e4a1a08fcca63c7fce91218"
  end

  depends_on "freetype" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.11"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def python3
    "python3.11"
  end

  def install
    # Fix hardcoded paths so they work on Linux and non-default prefixes.
    inreplace "setup.py" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
      s.gsub! %r{/usr(?!/local)}, HOMEBREW_PREFIX
    end

    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""

    system python3, *Language::Python.setup_install_args(prefix, python3), "build"
  end

  test do
    (testpath/"test.py").write <<~EOS
      import sys
      from pathlib import Path

      import fitz

      in_pdf = sys.argv[1]
      out_png = sys.argv[2]

      # Convert first page to PNG
      pdf_doc = fitz.open(in_pdf)
      pdf_page = pdf_doc.load_page(0)
      png_bytes = pdf_page.get_pixmap().tobytes()

      Path(out_png).write_bytes(png_bytes)
    EOS

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end
