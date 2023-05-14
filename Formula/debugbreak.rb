class Debugbreak < Formula
  desc "Break into the debugger programmatically"
  homepage "https://github.com/scottt/debugbreak"
  url "https://github.com/scottt/debugbreak/archive/refs/tags/v1.0.tar.gz"
  sha256 "62089680cc1cd0857519e2865b274ed7534bfa7ddfce19d72ffee41d4921ae2f"
  license "BSD-2-Clause"

  def install
    include.install "debugbreak.h"
    pkgshare.install "debugbreak-gdb.py"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <debugbreak.h>
      int main() {
        debug_break(); /* will break into debugger */
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-o", "test"
    assert_empty shell_output("./test", nil)
  end
end
