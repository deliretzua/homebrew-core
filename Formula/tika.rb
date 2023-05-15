class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.8.0/tika-app-2.8.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.8.0/tika-app-2.8.0.jar"
  sha256 "634af0e18ab3d0f222eb40ed2f766c917fd925936bd4171bb827c65c847abe44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, ventura:        "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, monterey:       "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e11bbd53a562a16f00e2703f75273b000abe4717d5954488ceaf8c9184e4d91a"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.8.0/tika-server-standard-2.8.0.jar"
    mirror "https://archive.apache.org/dist/tika/2.8.0/tika-server-standard-2.8.0.jar"
    sha256 "6cd277d742bcdf85395c418e2cfc09a88d741a43de9a316ee1ca42d4e5a86972"
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-#{version}.jar", "tika-rest-server"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")
  end
end
