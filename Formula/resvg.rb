class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "9b8095b797414ea3375405f7427ac04bd0067af80ba5e38d35cfd0b0fda25a9c"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "usvg")
    system "cargo", "install", *std_cargo_args

    system "cargo", "build", "--locked", "--lib", "--manifest-path", "c-api/Cargo.toml", "--release"
    include.install "c-api/resvg.h", "c-api/ResvgQt.h"
    lib.install "target/release/#{shared_library("libresvg")}", "target/release/libresvg.a"
  end

  test do
    (testpath/"circle.svg").write <<~EOS
      <svg xmlns="http://www.w3.org/2000/svg" height="100" width="100" version="1.1">
        <circle cx="50" cy="50" r="40" />
      </svg>
    EOS

    expected_resvg_sum = "5627f52bd81e589256ea60f4e0963a11364665e4ee6458f1c4664b72b8153aab"
    system bin/"resvg", testpath/"circle.svg", testpath/"test.png"
    assert_equal expected_resvg_sum, Digest::SHA256.hexdigest((testpath/"test.png").read)

    expected_usvg_sum = "043cbf51155560232320851f0379daf9514de5fcb0cc6b38df0925bb2514aba8"
    system bin/"usvg", testpath/"circle.svg", testpath/"test.svg"
    assert_equal expected_usvg_sum, Digest::SHA256.hexdigest((testpath/"test.svg").read)

    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <resvg.h>

      int main(int argc, char **argv) {
        resvg_init_log();
        resvg_options *opt = resvg_options_create();
        resvg_options_load_system_fonts(opt);

        resvg_render_tree *tree;
        int err = resvg_parse_tree_from_file(argv[1], opt, &tree);
        resvg_options_destroy(opt);
        if (err != RESVG_OK) {
            printf("Error id: %i\\n", err);
            abort();
        }

        resvg_size size = resvg_get_image_size(tree);
        int width = (int)size.width;
        int height = (int)size.height;

        printf("%d %d\\n", width, height);
        resvg_tree_destroy(tree);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lresvg", "-o", "test"
    assert_equal "160 35", shell_output("./test #{test_fixtures("test.svg")}").chomp
  end
end
