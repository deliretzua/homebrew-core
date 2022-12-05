class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.0.0_src.tar.gz"
  sha256 "ebf3d3afd589d771ed624070c4a79963d90eb7a974848b9f1c15cb2ef29363c2"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c2ee1e2052efdf141cc20a5e771550a0ee94e0ff84140f331e157830c3040244"
    sha256 cellar: :any,                 arm64_monterey: "1fd959ab3d6b3527a09659b2db4df78f8892714758b106a3e47b76fcb4f2dec0"
    sha256 cellar: :any,                 arm64_big_sur:  "76c031d32a5e08a6662aa4eb9fb608624132d40981928fe3123b4609abd8f9ef"
    sha256 cellar: :any,                 monterey:       "cd638bc927e069d8705fb94da9b09095b2e567b86d431370b03b0f3605f74a24"
    sha256 cellar: :any,                 big_sur:        "aae1f5343fcb87b2a21181db473beecba98fabb17bb64ee7189f89834137b6ea"
    sha256 cellar: :any,                 catalina:       "e7cec22ab3e5307aceb886347da8c66a519d46cfdf17a31841a1903ea2314a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56f1db0284c4dc6393c2130f21cfd0da50dccd0d40fb0dca31019ec4d927913e"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    mkdir "build" do
      system "qmake", "PREFIX=#{prefix}",
                                 "QMAKE_CXXFLAGS=#{ENV.cxxflags}",
                                 "CONFIG+=no_include_pwd",
                                 ".."
      system "make"

      if OS.mac?
        prefix.install "PC6001VX.app"
        bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
      else
        bin.install "PC6001VX"
      end
    end
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = fork do
      exec bin/"PC6001VX"
    end
    sleep 15
    assert_predicate user_config_dir/"pc6001vx.ini",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
