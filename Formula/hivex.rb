class Hivex < Formula
  desc "Library and tools for extracting the contents of Windows Registry hive files"
  homepage "https://libguestfs.org"
  url "https://download.libguestfs.org/hivex/hivex-1.3.23.tar.gz"
  sha256 "40cf5484f15c94672259fb3b99a90bef6f390e63f37a52a1c06808a2016a6bbd"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-only"]

  livecheck do
    url "https://download.libguestfs.org/hivex/"
    regex(/href=.*?hivex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "readline"

  uses_from_macos "pod2man" => :build
  uses_from_macos "libxml2"

  def install
    args = %w[
      --disable-ocaml
      --disable-perl
      --disable-python
      --disable-ruby
    ]

    system "./configure", *args, *std_configure_args, "--disable-silent-rules"
    system "make", "install"
    (pkgshare/"test").install "images/large"
  end

  test do
    assert_equal "305419896", shell_output("#{bin}/hivexget #{pkgshare}/test/large 'A\\A giant' B").chomp
  end
end
