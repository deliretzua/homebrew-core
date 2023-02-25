class Wxlua < Formula
  desc "Lua bindings for wxWidgets cross-platform GUI toolkit"
  homepage "https://github.com/pkulchenko/wxlua"
  url "https://github.com/pkulchenko/wxlua/archive/refs/tags/v3.2.0.2.tar.gz"
  sha256 "62abe571803a9748e19e86e39cb0e254fd90a5925dc5f0e35669e693cbdb129e"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/pkulchenko/wxlua.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "lua"
  depends_on "wxwidgets"

  def install
    lua = Formula["lua"]
    wxwidgets = Formula["wxwidgets"]
    lua_version = lua.version.major_minor

    args = %W[
      -DwxLua_LUA_LIBRARY_VERSION=#{lua_version}
      -DwxLua_LUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DwxLua_LUA_LIBRARY=#{lua.opt_lib/shared_library("liblua")}
      -DwxWidgets_CONFIG_EXECUTABLE=#{wxwidgets.opt_bin}/wx-config
      -DwxLua_LUA_LIBRARY_USE_BUILTIN=FALSE
    ]

    system "cmake", "-S", "wxLua", "-B", "build-wxlua", *args, *std_cmake_args
    system "cmake", "--build", "build-wxlua"
    system "cmake", "--install", "build-wxlua"

    (lib/"lua"/lua_version).install lib/shared_library("libwx") => "wx.so"
    prefix.install bin.glob("*.app")
  end

  test do
    (testpath/"example.wx.lua").write <<~EOS
      require('wx')
      print(wxlua.wxLUA_VERSION_STRING)
    EOS

    assert_match "wxLua #{version}", shell_output("lua example.wx.lua")
  end
end
