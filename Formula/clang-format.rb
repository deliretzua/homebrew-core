class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/llvm-16.0.3.src.tar.xz"
    sha256 "d820e63bc3a6f4f833ec69a1ef49a2e81992e90bc23989f98946914b061ab6c7"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/clang-16.0.3.src.tar.xz"
      sha256 "5fa9a398a7d3274d1d38e9f7c01c068f7d6d80f08de45d01c40f7177cdb20097"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/cmake-16.0.3.src.tar.xz"
      sha256 "b6d83c91f12757030d8361dedc5dd84357b3edb8da406b5d0850df8b6f7798b1"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/third-party-16.0.3.src.tar.xz"
      sha256 "b964f570b6fb08da2e8f6570797e656dfa208b99c05ae92e4bfeffcfeaddd2b8"
    end
  end

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd5fe1d2af15a0fe8b8572812e8a47269c8db6724180e6f8e0d23005ea38f230"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35df5fb92dba0a0e904aaed82dd9c8bdf0182b01f543ce9ed252b150975fcd06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c17f023a673c9a0379373c8ae270725b6a642d8ffbbc42f5ca6bf7c5ffd42c39"
    sha256 cellar: :any_skip_relocation, ventura:        "7a92a54ec0c8009617e2290b5841859deac7b2ef2c21efb8e32c64a51e85375c"
    sha256 cellar: :any_skip_relocation, monterey:       "f88b6cd4cc2178556eba58cdfc74433af3f5015940bae6ed6446d032062dea16"
    sha256 cellar: :any_skip_relocation, big_sur:        "2eea3bcd4ccfd322e6e1e4c1fe5f50e379e56947c2431b92b95bf850414f22ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfcf44abe41d4fc3fdfa1fc44b24724e388157da588976c62bd5dd2b071cc9e4"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
