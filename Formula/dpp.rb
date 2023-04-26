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

  # Match versions from dub.selections.json
  resource "libclang" do
    url "https://code.dlang.org/packages/libclang/0.3.1.zip"
    sha256 "ff6c8d5d53e3f59dbb280b8d370d19cb001e63aad6da99c02bdd2b48bfb31449"
  end

  resource "sumtype" do
    url "https://code.dlang.org/packages/sumtype/0.7.1.zip"
    sha256 "e27e026505bd9a7eb8f11cda12a3030c190a3d93f6b8dccfe7b22ffc36694e4e"
  end

  resource "unit-threaded" do
    url "https://code.dlang.org/packages/unit-threaded/2.1.3.zip"
    sha256 "bb306506cc69f51e3ff712590c9ce02dba16832171d34c0a6243a47ba4a936d6"
  end

  def install
    resources.each do |r|
      r.stage buildpath/"dub-packages"/r.name
      system "dub", "add-local", buildpath/"dub-packages"/r.name, r.version
    end

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
    system "dub", "build", "--skip-registry=all", "dpp"
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
