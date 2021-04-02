class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.5.0.tar.gz"
  sha256 "301c99bfe1c62d9f48f3b22a1f7795f61bd9b341ed904afd59d0ceb8693e295d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18e6e5f4c39f6b98a58ac1f0ebafa1d55e0c3a767dd43e5a13494175e34c8f29"
    sha256 cellar: :any_skip_relocation, big_sur:       "e18c594f6014ea5e02b00a8393d7f34dd3f7f52ce51c8650105709ae1966122b"
    sha256 cellar: :any_skip_relocation, catalina:      "6e503a3e3dc1752b3a034c29bd69f7db7e64b16475e7e1496abd74c1e2038dea"
    sha256 cellar: :any_skip_relocation, mojave:        "35a09c9fe20a5a3a5e02e274d9d25b551274953b939b1b9995451d03b68cbf2c"
  end

  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pkg-config"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install",
      "--no-default-features", "--features", "portaudio_backend,cursive/pancurses-backend", *std_cargo_args
  end

  test do
    stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
    stdin.puts "stty rows 80 cols 130"
    stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
    sleep 1
    Process.kill("INT", wait_thr.pid)

    assert_match "Please login to Spotify", stdout.read
  end
end
