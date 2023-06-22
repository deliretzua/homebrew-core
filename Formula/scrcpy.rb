class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v2.1.tar.gz"
  sha256 "57a277238d19d3471f37003d0d567bb8cde0a2b487b5cf91416129b463d9e8d5"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "15119a8e2a59c8fb04ce9334213b78aac9543f899e368053f0654707b97c5a41"
    sha256 arm64_monterey: "6fa648d71b58c7a80d6a9a1d66681aa3084e3637fe769fd837b943d32b8c1ab3"
    sha256 arm64_big_sur:  "01d2f90f67c08551a98a33c08378ee0aea458cd47768a8b8a29bd5817c2afe9c"
    sha256 ventura:        "684de832c6b10c40a02262b13bb4b63fe62e2503c9da6e1158bb442f848ae670"
    sha256 monterey:       "8cde3cdba91d5f50e83e8d00453352acd5826480f3decbb30c69d6f8ef94c9b8"
    sha256 big_sur:        "c47fc8cc7c266033531d9e6f33dbed9f648b55ddf1823b13022fae32acebb02e"
    sha256 x86_64_linux:   "f5afb6970b1ea03e94e542c2c941e43befb73a2d98bb9d8637a1b2352a2b5c01"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v2.1/scrcpy-server-v2.1"
    sha256 "5b8bf1940264b930c71a1c614c57da2247f52b2d4240bca865cc6d366dff6688"
  end

  def install
    r = resource("prebuilt-server")
    r.fetch
    cp r.cached_download, buildpath/"prebuilt-server.jar"

    mkdir "build" do
      system "meson", *std_meson_args,
                      "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
                      ".."

      system "ninja", "install"
    end
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    fakeadb = (testpath/"fakeadb.sh")

    # When running, scrcpy calls adb five times:
    #  - adb start-server
    #  - adb devices -l
    #  - adb -s SERIAL push ... (to push scrcpy-server.jar)
    #  - adb -s SERIAL reverse ... tcp:PORT ...
    #  - adb -s SERIAL shell ...
    # However, exiting on $3 = shell didn't work properly, so instead
    # fakeadb exits on $3 = reverse

    fakeadb.write <<~EOS
      #!/bin/sh
      echo "$@" >> #{testpath/"fakeadb.log"}

      if [ "$1" = "devices" ]; then
        echo "List of devices attached"
        echo "emulator-1337          device product:sdk_gphone64_x86_64 model:sdk_gphone64_x86_64 device:emulator64_x86_64_arm64 transport_id:1"
      fi

      if [ "$3" = "reverse" ]; then
        exit 42
      fi
    EOS

    fakeadb.chmod 0755
    ENV["ADB"] = fakeadb

    # It's expected to fail after adb reverse step because fakeadb exits
    # with code 42
    out = shell_output("#{bin}/scrcpy --no-display --record=file.mp4 -p 1337 2>&1", 1)
    assert_match(/ 42/, out)

    log_content = File.read(testpath/"fakeadb.log")

    # Check that it used port we've specified
    assert_match(/tcp:1337/, log_content)

    # Check that it tried to push something from its prefix
    assert_match(/push #{prefix}/, log_content)
  end
end
