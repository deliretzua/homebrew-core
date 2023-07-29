class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.23.0/nifi-1.23.0-bin.zip"
  mirror " https://archive.apache.org/dist/nifi/1.23.0/nifi-1.23.0-bin.zip"
  sha256 "4aeec454389ee046415152549e3bc9c0d438187b83e7d0f83bc88942801b00ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "891379f0718c5cb16793818a86815e5c9357ca21b1676d23bb47bd11555c9acf"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("11").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
