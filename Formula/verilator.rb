class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.012.tar.gz"
  sha256 "db19a7d7615b37d9108654e757427e4c3f44e6e973ed40dd5e0e80cc6beb8467"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "3a1c4cda58ea2ee8c3b763a9202f5112f819c228ec76139a7e9435f5aad9c3e0"
    sha256 arm64_monterey: "96c1bdf44d72f1184e7e01e2e184f11103ab93b3da74a75edfd60a81c28d0699"
    sha256 arm64_big_sur:  "18395654d07e9dd8b503cca3c69ddade45c52317a2e2a1c1cf1dfb96eb587a1c"
    sha256 ventura:        "b4f9b946bde9be75abd527c0395544b73ad7db8b6092eca8626ca76925d40e30"
    sha256 monterey:       "b47286cc3c1ed2a8b549e7badaf764bf138aade042e4bb97643d04a3940fd4de"
    sha256 big_sur:        "3c6bc909344d5778f65ff4d4a769c69b7298e154efc86acb29877f997fd47ca9"
    sha256 x86_64_linux:   "932cc156cb8845ea254cf843b64f0f4468f83b9cc08ad7246cc302959d1c80fd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "help2man" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"
  uses_from_macos "python", since: :catalina

  on_macos do
    depends_on "gcc"
  end

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  # error: specialization of 'template<class _Tp> struct std::hash' in different namespace
  fails_with gcc: "5"

  # Build hangs when using Clang
  # https://github.com/Homebrew/homebrew-core/pull/124827
  # https://github.com/Homebrew/homebrew-core/pull/130893
  # https://github.com/Homebrew/homebrew-core/pull/133912
  fails_with :clang

  def install
    # V3Lexer_pregen.yy.cpp:369:10: fatal error: FlexLexer.h: No such file or directory
    ENV.append_to_cflags "-isystem /Library/Developer/CommandLineTools/usr/include" if OS.mac?

    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    # `make` and `make install` need to be separate for parallel builds
    system "make"
    system "make", "install"

    # Avoid hardcoding build-time references that may not be valid at runtime.
    gcc = Formula["gcc"]
    cxx = OS.mac? ? gcc.opt_bin/"g++-#{gcc.any_installed_version.major}" : "c++"
    inreplace pkgshare/"include/verilated.mk" do |s|
      s.change_make_var! "CXX", cxx
      s.change_make_var! "LINK", cxx
      s.change_make_var! "PERL", "perl"
      s.change_make_var! "PYTHON3", "python3"
    end
  end

  test do
    (testpath/"test.v").write <<~EOS
      module test;
         initial begin $display("Hello World"); $finish; end
      endmodule
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "Vtest.h"
      #include "verilated.h"
      int main(int argc, char **argv, char **env) {
          Verilated::commandArgs(argc, argv);
          Vtest* top = new Vtest;
          while (!Verilated::gotFinish()) { top->eval(); }
          delete top;
          exit(0);
      }
    EOS
    system bin/"verilator", "-Wall", "--cc", "test.v", "--exe", "test.cpp"
    cd "obj_dir" do
      system "make", "-j", "-f", "Vtest.mk", "Vtest"
      expected = <<~EOS
        Hello World
        - test.v:2: Verilog $finish
      EOS
      assert_equal expected, shell_output("./Vtest")
    end
  end
end
