class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.73/asymptote-2.73.src.tgz"
  sha256 "36817b6ce9e1f748d5d551ab51a46d5fd7ce09c937fb01b01465cd427b3406f9"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "35dd1e97fca7edb69bde626f1f503c10275f8b221f71c1840953d4299ca081aa"
    sha256 arm64_big_sur:  "baae14036da02db6e2c5cc8ca637d759d1af8e13a6330bac953c802dc0e00190"
    sha256 monterey:       "a4f10101d0dc819abd76a2150d7bcb429f9eb136e8d83b4faae7a2ac0e34e19f"
    sha256 big_sur:        "8f3a6e7b6baacc43cf517168994b84626484c8f73f75655be5254a616e6ffde4"
    sha256 catalina:       "2ec57ee257c0706bfd1143d27e37c2179dd99a54e33aa882ba522ea13903f07c"
    sha256 x86_64_linux:   "e1765dd33095e894b1ca5879e9480defcf5132249dedd35caf5c85b237e573a5"
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "freeglut"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.73/asymptote.pdf"
    sha256 "306f3c4fbb71e0cd2b1830b6e55e9de32b9d47595679feca453c96bbb4e79803"
  end

  def install
    system "./configure", *std_configure_args

    # Avoid use of MacTeX with these commands
    # (instead of `make all && make install`)
    touch buildpath/"doc/asy-latex.pdf"
    system "make", "asy"
    system "make", "asy-keywords.el"
    system "make", "install-asy"

    doc.install resource("manual")
    (share/"emacs/site-lisp").install_symlink pkgshare
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF
    system "#{bin}/asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
