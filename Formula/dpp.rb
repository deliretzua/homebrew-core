class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.5.1",
      revision: "23339d566032419501b005e13f601bb6b6b1ebe5"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f43b39082cfb9fc5f6c8c7181d36a57737cd3d65b65218e273a50be45941cab3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2048200bfad735322eab2dd888599af2b2ae322b2a4c9dfafdc55145ce073f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "242b7b3771f2688095a2cff28b5949415973dcbf348958e4b7c24515bab98f80"
    sha256 cellar: :any_skip_relocation, ventura:        "b4051d8412efc83d7ee57cc1618acc6d15e88c1f1e5d5858dceff42fb6f3955e"
    sha256 cellar: :any_skip_relocation, monterey:       "7b75f0d1d503a3fbc0be2279629d6f4e9ee066dd4d8b970d85f1d66316511d47"
    sha256 cellar: :any_skip_relocation, big_sur:        "abb5a92808d3062045327eb5c88f51459719c9f7fd605955c47626f4ef775d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "616385f709f06d1db6899b3364b58f8057015795b6cc859f783dc243cfe8e043"
  end

  depends_on "dub" => :build
  depends_on "ldc" => [:build, :test]

  uses_from_macos "llvm" # for libclang

  def install
    # Use actual rdmd once it is separated out of the dmd formula
    (buildpath/"rdmd-bin/rdmd").write <<~EOS
      #!/bin/sh
      ldc2 -run $@
    EOS
    (buildpath/"rdmd-bin/rdmd").chmod 0755
    ENV.prepend_path "PATH", buildpath/"rdmd-bin"

    if OS.mac?
      toolchain_paths = []
      toolchain_paths << MacOS::CLT::PKG_PATH if MacOS::CLT.installed?
      toolchain_paths << MacOS::Xcode.toolchain_path if MacOS::Xcode.installed?
      dflags = toolchain_paths.flat_map do |path|
        %W[
          -L-L#{path}/usr/lib
          -L-rpath
          -L#{path}/usr/lib
        ]
      end
      ENV["DFLAGS"] = dflags.join(" ")
    end
    system "dub", "add-local", buildpath
    system "dub", "build", "dpp"
    bin.install "bin/d++"
  end

  test do
    (testpath/"c.h").write <<~EOS
      #define FOO_ID(x) (x*3)
      int twice(int i);
    EOS

    (testpath/"c.c").write <<~EOS
      int twice(int i) { return i * 2; }
    EOS

    (testpath/"foo.dpp").write <<~EOS
      #include "c.h"
      void main() {
          import std.stdio;
          writeln(twice(FOO_ID(5)));
      }
    EOS

    system ENV.cc, "-c", "c.c"
    system bin/"d++", "--compiler=ldc2", "foo.dpp", "c.o"
    assert_match "30", shell_output("./foo")
  end
end
