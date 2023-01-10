class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.100/bee-1.100.zip"
  sha256 "08955917eaff1d29cd453a4ed69cb5af9189a58ac760bf25cc6fa7f2d6acee8e"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee97ca7550e9278be404d41868d45259dea65224d9781b760f57497ac379c0f9"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"bee").write_env_script libexec/"bin/bee", Language::Java.java_home_env
  end

  test do
    (testpath/"bee.properties").write <<~EOS
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql://127.0.0.1/test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath/"bee").mkpath
    system bin/"bee", "-d", testpath/"bee", "dbchange:create", "new-file"
  end
end
