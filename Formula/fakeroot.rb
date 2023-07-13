class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.32.1.orig.tar.gz"
  sha256 "c072b0f65bafc4cc5b6112f7c61185f5170ce4cb0c410d1681c1af4a183e94e6"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e3625da085f31dc5faab87b27325b1fbafb7e102ffa03db823e24d147b10a14d"
    sha256 cellar: :any,                 arm64_monterey: "86a81663cbf4fe61f2b7cad10879393dfe94a79c3d8fd0da7f8e622938129c18"
    sha256 cellar: :any,                 arm64_big_sur:  "635cc865283e4ace7d92c786b3a1aaa9a21b1702c345037c635dec5dada9bb95"
    sha256 cellar: :any,                 ventura:        "66031772f6da7735c1f020bc078a4a140ed4fcd86291eabc2a92b23681a890ef"
    sha256 cellar: :any,                 monterey:       "97773fae81799fc7e08562bf858bc57793914161071778a925a01aa9119abde2"
    sha256 cellar: :any,                 big_sur:        "b97d57861b3a89a6c440b8e4e1e8e1eb89997ecc7b689b3985332aad8d3fd060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42483a63fed5d453f2334a9bb50c01673ab7806935bf1c8d96ce5d6476c21756"
  end

  # Needed to apply patches below. Remove when no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  # https://salsa.debian.org/clint/fakeroot/-/merge_requests/17
  patch :p0 do
    # The MR has a typo, so we use MacPorts' version.
    url "https://raw.githubusercontent.com/macports/macports-ports/0ffd857cab7b021f9dbf2cbc876d8025b6aefeff/sysutils/fakeroot/files/patch-message.h.diff"
    sha256 "6540eef1c31ffb4ed636c1f4750ee668d2effdfe308d975d835aa518731c72dc"
  end

  def install
    system "./bootstrap" # remove when patches are no longer needed

    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
