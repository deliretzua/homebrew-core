class Lpeg < Formula
  desc "Parsing Expression Grammars For LuaJIT"
  homepage "https://www.inf.puc-rio.br/~roberto/lpeg/"
  url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.2.tar.gz"
  mirror "https://github.com/neovim/deps/raw/master/opt/lpeg-1.0.2.tar.gz"
  sha256 "48d66576051b6c78388faad09b70493093264588fcd0f258ddaab1cdd4a15ffe"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?lpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "cmake" => :build
  depends_on "luajit" => [:build, :test]

  # We use Neovim's CMakeLists for compatibility with Neovim.
  # Update to latest commit at version bumps.
  resource "CMakeLists.txt" do
    url "https://raw.githubusercontent.com/neovim/neovim/4e5061dba765df2a74ac4a8182f6e7fe21da125d/cmake.deps/cmake/LpegCMakeLists.txt"
    sha256 "398d024cb4ac243f1f63e7d779cd01f2233b06c82d0629cac23ace9a4802134d"
  end

  def install
    resource("CMakeLists.txt").stage { buildpath.install "LpegCMakeLists.txt" => "CMakeLists.txt" }

    ENV.append_to_cflags "-Wl,-undefined,dynamic_lookup" if OS.mac?
    ENV.append_to_cflags "-I#{Formula["luajit"].opt_include}/luajit-2.1"

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args(install_libdir: "lib/lua/5.1")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (lib/"lua/5.1").install_symlink shared_library("liblpeg") => "lpeg.so"
  end

  test do
    (testpath/"test.lua").write <<~LUA
      local lpeg = require("lpeg")
      p = lpeg.R"az"^1 * -1
      print(p:match("hello"))
    LUA
    assert_equal "6", shell_output("luajit test.lua").chomp
  end
end
