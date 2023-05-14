class Lpeg < Formula
  desc "Parsing Expression Grammars For Lua"
  homepage "https://www.inf.puc-rio.br/~roberto/lpeg/"
  url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.2.tar.gz"
  mirror "https://github.com/neovim/deps/raw/master/opt/lpeg-1.0.2.tar.gz"
  sha256 "48d66576051b6c78388faad09b70493093264588fcd0f258ddaab1cdd4a15ffe"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?lpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22325d9fc7125511176621bf0bc1ab1490875255258e613b7646d688fb65895b"
    sha256 cellar: :any,                 arm64_monterey: "3f7b628261f3db631abd0af83e6f579504838b4b00f52dd4ad83ec8bb87a3a7c"
    sha256 cellar: :any,                 arm64_big_sur:  "2cf8b5089a23d86f10ae205d93bfd335af81a449acc4d40c25e2675a06e6d33b"
    sha256 cellar: :any,                 ventura:        "da6e45a73eb1e54264b5d04fc04c13605bc799606e15afc37e592e420ef8f813"
    sha256 cellar: :any,                 monterey:       "46819d3db41b35eacab885a8314f69de5417dd33f1dd8a7931292bb214687479"
    sha256 cellar: :any,                 big_sur:        "4c18893291c3fcbcfa98991fce241f95357af66df9160a3bbee5520a8573d5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e3da90255288f5b4ebdb5d9fea1b4a40704dd20b393643cf42cea8259a5706a"
  end

  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]

  def make_install_lpeg_so(luadir, dllflags, abi_version)
    system "make", "LUADIR=#{luadir}", "DLLFLAGS=#{dllflags.join(" ")}", "lpeg.so"
    (share/"lua"/abi_version).install_symlink pkgshare/"re.lua"
    (lib/"lua"/abi_version).install "lpeg.so"
    system "make", "clean"
  end

  def install
    dllflags = %w[-shared -fPIC]
    dllflags << "-Wl,-undefined,dynamic_lookup" if OS.mac?

    luajit = Formula["luajit"]
    lua = Formula["lua"]

    make_install_lpeg_so(luajit.opt_include/"luajit-2.1", dllflags, "5.1")
    make_install_lpeg_so(lua.opt_include/"lua", dllflags, lua.version.major_minor)

    doc.install "lpeg.html", "re.html"
    pkgshare.install "test.lua", "re.lua"
  end

  test do
    system "lua", pkgshare/"test.lua"
    system "luajit", pkgshare/"test.lua"
  end
end
