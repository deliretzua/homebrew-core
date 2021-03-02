class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/releases/download/v1.8/wolfmqtt-1.8.0.tar.gz"
  sha256 "1d57dd90a963d79a5ec58261392d14451665c59205bdc826082266ff1b5733f2"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "671d2455c56297175e060a87686e45d9a8343e360f99cb94030adf0679aa6f73"
    sha256 cellar: :any, big_sur:       "e07f57c741c69ef671c74c08a2dc9207235c9f31392a147570f27c17bfe532a9"
    sha256 cellar: :any, catalina:      "073807b984df8fb86ffde192cb3c0ace7c7f139d81da937e71874fcaa02e820b"
    sha256 cellar: :any, mojave:        "32e32e9f2d87974550fdc18e054f639d0a138e74aace8a2ceb639b992cdd54f1"
    sha256 cellar: :any, high_sierra:   "3e2a29fd675291511f203d094e235461483a7a0d8135b286c94900dd9e25f963"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wolfssl"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-nonblock
      --enable-mt
      --enable-mqtt5
      --enable-propcb
      --enable-sn
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOT
      #include <wolfmqtt/mqtt_client.h>
      int main() {
        MqttClient mqttClient;
        return 0;
      }
    EOT
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwolfmqtt", "-o", "test"
    system "./test"
  end
end
