class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.53.0",
      revision: "c61b0bc1280233e45039393c9cea793bc3e6d449"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54024949bba75e3889f3068d86412f892d88981cd653eceb1fd4326e24eb7e47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9810c1d6f080849a521a436447cf780687ec78585edb7520b447c22f95e164ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c56faded83e92f081d256cc33fb325b188595b407f37cea65b96cc956247445"
    sha256 cellar: :any_skip_relocation, ventura:        "0c8e496e9a873aab56a09f39bd588120d386150ad49eff431f1e63279cc9bbae"
    sha256 cellar: :any_skip_relocation, monterey:       "0874fba7efe94b3bae0630e139afe9660b444052c079988bfc8e9198aade5c34"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f4863df94cd8a63ba485fd3f6599a6b2571ed85c5e5ac7ce64ce8bcf510f3f4"
    sha256 cellar: :any_skip_relocation, catalina:       "66f099e1c12dc445c90f4a8b57e7ce00c664bcfc6e614fb23ab9fc9622771254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c168b4822f329336dbd00ee7340972e91fdef73b2ae54d8b62e6f20a61a8ac3"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  # We use LLVM to work around an error while building bundled `google-benchmark` with GCC
  fails_with :gcc do
    cause <<-EOS
      .../src/gbenchmark/src/thread_manager.h:50:31: error: expected ')' before '(' token
         50 |   GUARDED_BY(GetBenchmarkMutex()) Result results;
            |                               ^
    EOS
  end

  def install
    inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\"" if OS.linux?

    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"
    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
