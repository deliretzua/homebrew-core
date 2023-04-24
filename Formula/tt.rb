class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v1.0.2/tt-1.0.2-complete.tar.gz"
  sha256 "e4afa215b89e9c69385caaac71068523bf4024de5c59a6c89a0ffa8eea482cb7"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "90f36785bcedab0e5592ca6779929fe572ebeb7389075e79e4883727a2cac508"
    sha256 cellar: :any,                 arm64_monterey: "80223d4b9b72cd82912cbf727968cb8adea845572070b2fd4f172d5f2f2c7737"
    sha256 cellar: :any,                 arm64_big_sur:  "cbdd5b31e080d0b390daa028d23785ef02d3c38d8435b49e57591a9872eaacf5"
    sha256                               ventura:        "a6d00341d1f8ff22a36c9b6715ff04d757082efe5c6a44ebb7ba4a1ef3332a6f"
    sha256                               monterey:       "05cc188751c21b585097775c6abc0c825b2e5edb2bc9b51db0e11ebc13f9550a"
    sha256                               big_sur:        "cceeab18a63bdba2ef136a46da2a840694c1763b7665ef3a1b7e3805099c6d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffec5fa2dcd925fe8126372445bfe81318c5ba83799ba2ed36e2a31d0bf4d1f7"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc/"tarantool").install "tt.yaml.default" => "tt.yaml"
    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
