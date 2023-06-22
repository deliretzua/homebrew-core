class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.5.0.tar.gz"
  sha256 "133204df58f028bf51cac75a3afc9fdfcb6f4e8046f53e8d7fa0387825d0f054"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfb274b3d46c40950d523b00094049d621f1f66c45453b9c671565d258e812e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0551a2c08e8cba8df4dcbc3bd87814b51b7c7c98f02a50e6c622035f29610ed1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c4ecc257e65dd403b7b533915d392b7f4f87a2ddd864b165880280cda1d0d2f"
    sha256 cellar: :any_skip_relocation, ventura:        "84f6a3a4d41c527715c17961dcefb1e858cae391ff48f7bc4fd0df51a20d8e61"
    sha256 cellar: :any_skip_relocation, monterey:       "14f67514f6eaa385cc5261cec702b9fa2fb02cd7db04c61d509f35c3ef43612b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f346c46d9ba31120858b7e79dcd533918671f3ef51cfa03a5f0bc5f17ccf4870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c33312b4b52b77b7f4011b2bc0f39c752f393b2c3d73a8ee91a684e746a11f"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
