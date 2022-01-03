class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.4.tar.gz"
  sha256 "222e08e429dbac77b0e1a6a752f6ace29863495185459c827c3fd5fc699e14cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bbb110ec7dd941c47d6acd7a1809474485e2d8634cc19380fc1dc478895f89e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9ca0d8424bb2a50d9366252e03755997417329ed8efa3e8e31516f4ffbe62cf"
    sha256 cellar: :any_skip_relocation, monterey:       "2fcd2481493066a1da134e4066fa9c3c7f7cce3d4169f51cdba780102924270b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9053d7422b59cf85e22a36a57a7d3250b8b87e4cbf1e627d168c1feebc4b8da4"
    sha256 cellar: :any_skip_relocation, catalina:       "07af94e2ffcf3586e5e0918990117c2ab6e275b7ebbd864212e0367aad156676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6f123596076c32c8b8b5d9893458f88dad1331283b3e4e1f2569f94cac695f3"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "tcl-tk"

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v35.1.tar.gz"
    sha256 "1b5c48d2abd59de0738d1fc1e6204e44979ad2a1a26e8e22a2d6215dd502c797"
  end

  def install
    luaversion = Formula["lua"].version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use Lmod, you should add the init script to the shell you are using.

      For example, the bash setup script is here: #{opt_prefix}/init/profile
      and you can source it in your bash setup or link to it.

      If you use fish, use #{opt_prefix}/init/fish, such as:
        ln -s #{opt_prefix}/init/fish ~/.config/fish/conf.d/00_lmod.fish
    EOS
  end

  test do
    sh_init = "#{prefix}/init/sh"

    (testpath/"lmodtest.sh").write <<~EOS
      #!/bin/sh
      . #{sh_init}
      module list
    EOS

    assert_match "No modules loaded", shell_output("sh #{testpath}/lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
