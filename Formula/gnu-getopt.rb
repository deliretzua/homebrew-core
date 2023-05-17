class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.tar.xz"
  sha256 "32b30a336cda903182ed61feb3e9b908b762a5e66fe14e43efb88d37162075cb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e007ef087b220f61b6ab26ace9bc2459883f0e2c437cfce298c916bc2b588820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ff319b6a576b32e06c5c3227eff3d3aeb9cc4c4ecf82fe894d43b4594735ef0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "257fddc790f816ced676ce58a3bdfccebceb2c0357d4f0d64fe43fb88fd7cd8a"
    sha256 cellar: :any_skip_relocation, ventura:        "764658575d964274c12b57a38df3cd5877ddd2b1b5b47c42c9d9580870408e37"
    sha256 cellar: :any_skip_relocation, monterey:       "a2ec1d844554f167042583afb86dadeae8a63fd1351c8abb88a2d59a95ea8261"
    sha256 cellar: :any_skip_relocation, big_sur:        "c25031c8bc41e5edb2ee9e52fd163ed31be33cdfa9eb41583c77880e9e8df9fb"
    sha256 cellar: :any_skip_relocation, catalina:       "2be0ba0cdb76b0f56f5032f1097f5e42897075ca87454b776eae0c6062ed42a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d2f5de09e2e8b566cb82a21602389c3c76eb39c04082f11e601127e70d32cb7"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
