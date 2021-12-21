class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_10/Gauche-0.9.10.tgz"
  sha256 "0f39df1daec56680b542211b085179cb22e8220405dae15d9d745c56a63a2532"
  license "BSD-3-Clause"
  revision 4

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?Gauche[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0eb649b466977e44393c3eb90cef8881d47e5f8614546d1a5658be2eb32096fb"
    sha256 arm64_big_sur:  "bb12debe2a6d30c6d97f14641600aacf0220cf3f50fcf9437dec29c8b6e3b9c8"
    sha256 monterey:       "664e1c541fc7cf1d2bc0692d09e116f4986350f53850430e975328b3b7129ece"
    sha256 big_sur:        "b1d8f0dd8a2454b25745e91c5ead4bc228597bf1efed91d0dc92580a3e953827"
    sha256 catalina:       "9a1f381af1d275946aee6655b14387c547f20d82f5ea92f5e32221221d0f0647"
    sha256 x86_64_linux:   "45f73c386af54c74febe68a0c0e022eb534e6d521ff8190789cd01cd185b07ab"
  end

  depends_on "mbedtls@2"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end
