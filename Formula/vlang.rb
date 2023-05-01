class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/refs/tags/0.3.4.tar.gz"
  sha256 "7e251dd1748d16090348da4a29abd85dfe8c48aebc47bd9c23e91ed18e0c5ba1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db37c4b868fa3931945eaec6c00857fff1f7e988be75484e8312bfb006e6baed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0adde1c97a886f43a27de8e3d384d5dc59820a9b9bb9e704d492e77e438262dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c46567536b07e0198a6ffc97e8c621f668c2a188bd19939bbdde9b779f7f6d7a"
    sha256 cellar: :any_skip_relocation, ventura:        "cf91b254e3ad5c67ef31c11f5d626e9df36f1b6239dca93432b27f2ee38ff6d5"
    sha256 cellar: :any_skip_relocation, monterey:       "9c2f3bb27bb25ad03ee9e821a21a897aab6c2fa50e9c51bde910b8432ba59983"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1fdeb24e25896919c8aa604978fe15f67bde3f0922634ccd42d8f835c8fc41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4795b32eaa5d86770ab2722fe1564296678b2c0995604baf960132b015429088"
  end

  depends_on "bdw-gc"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "6be6daffdbd8227595aea70cc981bf4c634decb7"
    on_big_sur :or_older do
      patch do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/4a51a527e534534c3ddc6801c45d3a3a2c8fbd5a/vlang/vc.patch"
        sha256 "0e0a2de7e37c0b22690599c0ee0a1176c2c767ea95d5fade009dd9c1f5cbf85d"
      end
    end
  end

  # upstream discussion, https://github.com/vlang/v/issues/16776
  # macport patch commit, https://github.com/macports/macports-ports/commit/b3e0742a
  patch :DATA

  def install
    inreplace "vlib/builtin/builtin_d_gcboehm.c.v", "@PREFIX@", Formula["bdw-gc"].opt_prefix

    resource("vc").stage do
      system ENV.cc, "-std=gnu99", "-w", "-o", buildpath/"v1", "v.c", "-lm"
    end
    system "./v1", "-no-parallel", "-o", buildpath/"v2", "cmd/v"
    system "./v2", "-o", buildpath/"v", "cmd/v"
    rm ["./v1", "./v2"]
    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end

__END__
diff --git a/vlib/builtin/builtin_d_gcboehm.c.v b/vlib/builtin/builtin_d_gcboehm.c.v
index 0a13b64..23fca2b 100644
--- a/vlib/builtin/builtin_d_gcboehm.c.v
+++ b/vlib/builtin/builtin_d_gcboehm.c.v
@@ -31,12 +31,12 @@ $if dynamic_boehm ? {
 } $else {
 	$if macos || linux {
 		#flag -DGC_BUILTIN_ATOMIC=1
-		#flag -I @VEXEROOT/thirdparty/libgc/include
-		$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
+		#flag -I @PREFIX@/include
+		$if (!macos && prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
 			// TODO: replace the architecture check with a `!$exists("@VEXEROOT/thirdparty/tcc/lib/libgc.a")` comptime call
 			#flag @VEXEROOT/thirdparty/libgc/gc.o
 		} $else {
-			#flag @VEXEROOT/thirdparty/tcc/lib/libgc.a
+			#flag @PREFIX@/lib/libgc.a
 		}
 		$if macos {
 			#flag -DMPROTECT_VDB=1
