class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "https://www.einval.com/~steve/software/jigdo/"
  url "https://www.einval.com/~steve/software/jigdo/download/jigdo-0.8.1.tar.xz"
  sha256 "b1f08c802dd7977d90ea809291eb0a63888b3984cc2bf4c920ecc2a1952683da"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  head "https://git.einval.com/git/jigdo.git", branch: "upstream"

  livecheck do
    url "https://www.einval.com/~steve/software/jigdo/download/"
    regex(/href=.*?jigdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2a7d61d39591e962966019d3d3925e6ea7799233805253deefa92a531f648cd5"
    sha256 arm64_monterey: "87d951b1c24be108f740eae7378dde28ba28dd7994bfd6758161a6d0bc8bb15d"
    sha256 arm64_big_sur:  "bc9b2ee804e6a0f51b5317ee21f7692b38fe6129b6319037e5bb6069ba80a0f3"
    sha256 ventura:        "39868f6ad957c0a31296e9d82243a905bba103d54f8cd8334acdcd5a17bb29ef"
    sha256 monterey:       "ee860a28d3dc2f0c9c51dbe5e245a048b11cb5fef3b4e71f7846f0c5e014cb4e"
    sha256 big_sur:        "af5dd0ccfda2a1e1e7355c9dd3fab85c4b7024bb8d95b29aa3e0ca84c5d25458"
    sha256 catalina:       "12f14d188a937f63899fd28c436597f15867440d952538f0bc73ee9d9628852d"
    sha256 x86_64_linux:   "fd0973ae7891e7ea56eaffd85a57afd00688c035586fe00856b5b34544a5f3d4"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gettext" => :build # for msgfmt
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "./configure", *std_configure_args, "--mandir=#{man}"

    # replace non-existing function
    inreplace "src/compat.hh", "return truncate64(path, length);", "return truncate(path, length);" if OS.mac?

    # disable documentation building
    (buildpath/"doc/Makefile").atomic_write "all:\n\techo hello"

    # disable documentation installing
    inreplace "Makefile", "$(INSTALL) \"$$x\" $(DESTDIR)$(mandir)/man1", "echo \"$$x\""

    system "make"
    system "make", "install"
  end

  test do
    system bin/"jigdo-file", "make-template", "--image=#{test_fixtures("test.png")}",
                                              "--template=#{testpath}/template.tmp",
                                              "--jigdo=#{testpath}/test.jigdo"

    assert_path_exists testpath/"test.jigdo"
    assert_path_exists testpath/"template.tmp"
    system bin/"jigdo-file", "make-image", "--image=#{testpath/"test.png"}",
                                           "--template=#{testpath}/template.tmp",
                                           "--jigdo=#{testpath}/test.jigdo"
    system bin/"jigdo-file", "verify", "--image=#{testpath/"test.png"}",
                                       "--template=#{testpath}/template.tmp"
  end
end
