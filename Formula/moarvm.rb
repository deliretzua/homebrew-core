class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2021.12/MoarVM-2021.12.tar.gz"
  sha256 "d49bbeb10d9616c2d87a7fadd1c6bb7a5ce11c19c7c44bbb8bef76f25b505c4f"
  license "Artistic-2.0"

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "fdd245cf7a23ec7044b5279672106ee2b28f43b0db3d74d6fc22e0c70b6ee5e2"
    sha256 arm64_big_sur:  "2d557279d080eb47d400a57e4edff28347175cf13086c0dfe186e0220b71bd3c"
    sha256 monterey:       "161d3a3a052b55859f6d70718351a799a1b7de30cb139620a454de69d0166088"
    sha256 big_sur:        "be70dfbceb7b4e670a20d58394ac1b39681e847201159921783d88498b9405dc"
    sha256 catalina:       "fb978591b171343c2f1ae121ca746050bb6b936ade1cfc997f35317c8c057334"
    sha256 x86_64_linux:   "1e1d807aedc37476f21df94cad713b403263e29a1ed229f94dbb25745e9e2f1c"
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2021.12/nqp-2021.12.tar.gz"
    sha256 "0e1d534fd1ee61a4c8072309bafbc04660e9ae72d88618daa0e8f15022f0d913"
  end

  def install
    libffi = Formula["libffi"]
    ENV.prepend "CPPFLAGS", "-I#{libffi.opt_lib}/libffi-#{libffi.version}/include"
    configure_args = %W[
      --has-libatomic_ops
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
      --prefix=#{prefix}
    ]
    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
