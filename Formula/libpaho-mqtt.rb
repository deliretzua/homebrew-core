class LibpahoMqtt < Formula
  desc "Eclipse Paho C client library for MQTT"
  homepage "https://eclipse.github.io/paho.mqtt.c/"
  url "https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v1.3.12.tar.gz"
  sha256 "6a70a664ed3bbcc1eafdc45a5dc11f3ad70c9bac12a54c2f8cef15c0e7d0a93b"
  license "EPL-2.0"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOT
      #include <stdio.h>
      #include <stdlib.h>
      #include <MQTTClient.h>

      int main(int argc, char* argv[]) {
          MQTTClient client;
          MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;

          return 0;
      }
    EOT
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpaho-mqtt3a", "-o", "test"
    system "./test"
  end
end
