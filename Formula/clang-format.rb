class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.4/llvm-16.0.4.src.tar.xz"
    sha256 "28cdf0e409cba177436693e2749e0ab75cd9e83a3fac1a4d35ecd6b8e9aed882"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.4/clang-16.0.4.src.tar.xz"
      sha256 "56f5797c20834769d4bf6c35b1677cebf31d27ad34d5c9b8d9f0237c1d11b51a"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.4/cmake-16.0.4.src.tar.xz"
      sha256 "1a366c5f7a7a0efa2f7ede960717f26f5332df28adc9b3c47516a859de2ccf7b"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.4/third-party-16.0.4.src.tar.xz"
      sha256 "760c72eb27ea0ccb21b1d9d25c2ae7b1fc47fd087a06be036d8ee1ad8e2fbcd7"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ec0749588805607971028df71c4a9deffe7f7045d5f5073bacd9c6939f0416"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2042af5f3da3ee949b30d8a55169f183fcabf91e8cdabdbf752ea890c73839e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12a91c7ebc1e3831e6f24d2e59fd00f2e4535dc97355a7d96e417c0cbba806d9"
    sha256 cellar: :any_skip_relocation, ventura:        "b2da2d2df9f700aa55e732a22f88e7586bb8f6a91724d815bad9e2f77e17b9b1"
    sha256 cellar: :any_skip_relocation, monterey:       "983ca202530661aeaa1eb21e4a05a06658fc792c7cdcf48ec0af767149c47470"
    sha256 cellar: :any_skip_relocation, big_sur:        "099953f96c59fc7431e7f0c96cfd75b37637f0ad3bbf5e595b779c8cc8abc817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96568c42132bf52db966084f27759ab4874db997c8e1a68923e65818ceb544b2"
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
