class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.5.1.src.tar.xz"
  sha256 "4b939aac113efcdf68060d0d39d3eb9228e8f6a4304a319b7fc3ccaff4dcbb66"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f0bd981bb79917bd27d3a06cf7167f8d7180f44e83bc037fc557c999cfc8accb"
    sha256 cellar: :any,                 arm64_monterey: "72d900c9d76841fbb2fbceeee1cea8f1dddfc9d6ab2e440d22c75a061475bb0d"
    sha256 cellar: :any,                 arm64_big_sur:  "5207db84833ea2f7a2c11d360b966dbe4370b86d60128af49db07ddf8be67f8e"
    sha256 cellar: :any,                 ventura:        "f54f1e2db3e45c2e43a28e038151a43d5c4ef16a87c5365607f6ec91627fa7ae"
    sha256 cellar: :any,                 monterey:       "635e79f53148290193825cfb5253cdb2e0c4c68a1cbaa5dc137d47a1a4b1fd5d"
    sha256 cellar: :any,                 big_sur:        "ad514146a01962d4cfe11f1836a8cd40d3fc96fcfa736f4a19c8bbbd7c7b75fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebce4271d7f9f27c5dfb08dcc6355a4bf9d539800f3d4b2f8945ea6c123ec470"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libarchive" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "numpy"
  depends_on "suite-sparse"
  depends_on "tinyxml"

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # regenerate configure due to `cannot find required auxiliary files: config.guess` issue
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end
