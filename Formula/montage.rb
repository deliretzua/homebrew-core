class Montage < Formula
  desc "Toolkit for assembling FITS images into custom mosaics"
  homepage "http://montage.ipac.caltech.edu"
  url "http://montage.ipac.caltech.edu/download/Montage_v6.0.tar.gz"
  sha256 "1f540a7389d30fcf9f8cd9897617cc68b19350fbcde97c4d1cdc5634de1992c6"
  license "BSD-3-Clause"
  head "https://github.com/Caltech-IPAC/Montage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "304f02cffd94ee9e118026fda40db0f27d4ae25c2d42c74e45b3426d11f1ed3d"
    sha256 cellar: :any_skip_relocation, catalina:    "0335521dd15d7debbfb5db21efbf5f751c571d406fd91aeaa9996226cca63d33"
    sha256 cellar: :any_skip_relocation, mojave:      "ee1b94e776a2ad68ea41b1edb6a3fb549c43bb373f3f7b9fb3709e4e4fbbb4e8"
    sha256 cellar: :any_skip_relocation, high_sierra: "3a8fab4097bd0dd0524a5a482065284d35ea0fdd946fb1f5d5ea1e103f5d4443"
    sha256 cellar: :any_skip_relocation, sierra:      "70b1769202095b84da05fe00a1934d8e8da3fd08b7ddb7135937f4cdc0107f07"
    sha256 cellar: :any_skip_relocation, el_capitan:  "503c3e946aa0d8f277b5e4a5aab75086d5c895551fa679a3129183b95f89b236"
  end

  depends_on "cfitsio"
  depends_on "freetype"
  depends_on "jpeg-turbo"

  uses_from_macos "bzip2"

  conflicts_with "wdiff", because: "both install an `mdiff` executable"

  def install
    # Avoid building bundled libraries
    libs = %w[bzip2 cfitsio freetype jpeg]
    buildpath.glob("lib/src/{#{libs.join(",")}}*").map(&:rmtree)
    inreplace "lib/src/Makefile", /^[ \t]*\(cd (?:#{libs.join("|")}).*\)$/, ""
    inreplace "MontageLib/Makefile", %r{^.*/lib/src/(?:#{libs.join("|")}).*$\n}, ""
    inreplace "MontageLib/Viewer/Makefile.#{OS.kernel_name.upcase}",
              "-I../../lib/freetype/include/freetype2",
              "-I#{Formula["freetype"].opt_include}/freetype2"

    ENV.deparallelize # Build requires targets to be built in specific order
    system "make"
    bin.install Dir["bin/m*"]
  end

  def caveats
    <<~EOS
      Montage is under the Caltech/JPL non-exclusive, non-commercial software
      licence agreement available at:
        http://montage.ipac.caltech.edu/docs/download.html
    EOS
  end

  test do
    system bin/"mHdr", "m31", "1", "template.hdr"
  end
end
