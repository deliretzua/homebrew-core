class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.3/llvm-15.0.3.src.tar.xz"
    sha256 "c39aec729662416dcbf0bfe53a9786b34e7d93d02908a0779a2f6d83ad0a4a27"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.3/clang-15.0.3.src.tar.xz"
      sha256 "96036052694e703d159c995bda203b59d1ff185c6879189b9eba837726e1738c"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.3/cmake-15.0.3.src.tar.xz"
      sha256 "21cf3f52c53dc8b8972122ae35a5c18de09c7df693b48b5cd8553c3e3fed090d"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32a74827d84c4bcfc38695ba300ff4e97dec72c27e062b090b8e1dd9057a7e0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8cacf6bf92f6e79daa754d0cd6c25be7f1955051bc9ca23752753bc6ba8ea30"
    sha256 cellar: :any_skip_relocation, monterey:       "a71cafe16a6abdf238da01030222d8b802b423d235240e9e6c5699ba563e71a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f83094a0d9e5823ac98cefa201e92442711628b42eb7caa998a5eb8debca64c6"
    sha256 cellar: :any_skip_relocation, catalina:       "40ee0b5c33044629deef1ad5626add2d218ed832ce83b9086e1cb76b51ccdbf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c238acfb23f1171032b50159ae2b601746dc77dc49ae2b5ce97104ceff8b4d22"
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
