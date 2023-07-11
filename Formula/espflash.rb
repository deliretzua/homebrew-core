class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "01b65bdd7c22b422d18db6cf186cb788151f0ca0eda9533ff9478aaf7255a2cf"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  on_macos do
    depends_on "libuv" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "espflash")
  end

  test do
    stable.stage testpath
    output = shell_output("#{bin}/espflash flash espflash/tests/resources/esp32_hal_blinky --port COMX 2>&1", 1)
    assert_match "espflash::connection_failed", output

    assert_match version.to_s, shell_output("#{bin}/espflash --version")
    assert_match "A command-line tool for flashing Espressif devices", shell_output("#{bin}/espflash --help")
  end
end
