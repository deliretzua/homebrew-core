class Libfastjson < Formula
  desc "Fast json library for C"
  homepage "https://github.com/rsyslog/libfastjson"
  url "https://download.rsyslog.com/libfastjson/libfastjson-1.2304.0.tar.gz"
  sha256 "ef30d1e57a18ec770f90056aaac77300270c6203bbe476f4181cc83a2d5dc80c"
  license "BSD-2-Clause"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libfastjson/json.h>

      int main() {
        char json_string[]  = "{\\"message\\":\\"Hello world!\\"}";
        struct fjson_object* root;
        struct fjson_object* message;

        root = fjson_tokener_parse(json_string);
        if (root == NULL) {
          fprintf(stderr, "Parsing failed\\n");
          return 1;
        }

        if (fjson_object_object_get_ex(root, "message", &message)) {
          printf("%s\\n", fjson_object_get_string(message));
        } else {
          fprintf(stderr, "Failed to get 'message' field\\n");
        }

        fjson_object_put(root);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lfastjson", "-o", "test"
    system "./test"
  end
end
