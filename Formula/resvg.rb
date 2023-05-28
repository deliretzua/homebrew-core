class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "5016330d8ee79abf5065f589b3b32ac0ae7abf7ce7f314dc6c8112df036d513e"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8c5e8fb410d5c325d3e2b7db0ce72b4fac7b9d8a062faadcf6a9f80649eec111"
    sha256 cellar: :any,                 arm64_monterey: "a81aa75c21d4f1ec772aea359cc049d9f8dd84da3f5c6db04a7934e41b3d1dda"
    sha256 cellar: :any,                 arm64_big_sur:  "7f9c787c23e97e3c6e22a9a171261a8ac055910f4d3f65d2beb5113a50cd0a71"
    sha256 cellar: :any,                 ventura:        "13ad19f8168c290670920959a982bc0dddc5091346115c4eb4a17c6309ab19ea"
    sha256 cellar: :any,                 monterey:       "70173648f608370c4973bbfbf265eb54ed7d7eb98667d090173f2dea7558f5ad"
    sha256 cellar: :any,                 big_sur:        "b84605508025283e3e386ac52f751594ddafff00b726bd072a1d7b4af5cabedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5753b4a05857d34502ff0fb8e73cee8f502e755e54592d4eee37798b2e49978"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/usvg")
    system "cargo", "install", *std_cargo_args(path: "crates/resvg")

    system "cargo", "build", "--locked", "--lib", "--manifest-path", "crates/c-api/Cargo.toml", "--release"
    include.install "crates/c-api/resvg.h", "crates/c-api/ResvgQt.h"
    lib.install "target/release/#{shared_library("libresvg")}", "target/release/libresvg.a"
  end

  test do
    (testpath/"circle.svg").write <<~EOS
      <svg xmlns="http://www.w3.org/2000/svg" height="100" width="100" version="1.1">
        <circle cx="50" cy="50" r="40" />
      </svg>
    EOS

    system bin/"resvg", testpath/"circle.svg", testpath/"test.png"
    assert_predicate testpath/"test.png", :exist?

    system bin/"usvg", testpath/"circle.svg", testpath/"test.svg"
    assert_predicate testpath/"test.svg", :exist?

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
