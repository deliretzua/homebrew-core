class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.5.0.tar.gz"
  sha256 "e5b57537c741400cf6134b428fc1689a649d7d38d9bb9c1b6d64f092ea28178a"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d429069173b1bbc6a4fc473596b1f56f9ae505961420d141f91e1fd6134ad766"
    sha256 cellar: :any,                 arm64_big_sur:  "93a6e5780531240b7e78444cb364a9cf4f7dff1275a19e42d8a1adb0877001f7"
    sha256 cellar: :any,                 monterey:       "fa514d241a73a459cc92171cccf64a9867e31fc2285c7130e8b4b3a6323c0db9"
    sha256 cellar: :any,                 big_sur:        "0026d3ff334c394482b8b252f4a7de078554cf59d0db31f9e7e94b0947bc3376"
    sha256 cellar: :any,                 catalina:       "379b4e7d6b4b40964b80211adff9d7224b3c10b5091eb8127ce939015e031526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e97e1ba13401a2f358a5a2477ca0d78fe806a75375d2636dfa39cc198f6fbce"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "swig" => :build
  depends_on "hwloc"

  # Fix installation of Python components
  # See https://github.com/oneapi-src/oneTBB/issues/343
  patch :DATA

  # Fix thread creation under heavy load.
  # https://github.com/oneapi-src/oneTBB/pull/824
  # Needed for mold: https://github.com/rui314/mold/releases/tag/v1.4.0
  patch do
    url "https://github.com/oneapi-src/oneTBB/commit/f12c93efd04991bc982a27e2fa6142538c33ca82.patch?full_index=1"
    sha256 "637a65cca11c81fa696112aca714879a2202a20e426eff2be8d2318e344ae15c"
  end

  def install
    args = %w[
      -DTBB_TEST=OFF
      -DTBB4PY_BUILD=ON
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install buildpath.glob("build/static/*/libtbb*.a")

    cd "python" do
      ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
      python = Formula["python@3.10"].opt_bin/"python3.10"

      tbb_site_packages = prefix/Language::Python.site_packages(python)/"tbb"
      ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(source: tbb_site_packages)}"

      ENV["TBBROOT"] = prefix
      system python, *Language::Python.setup_install_args(prefix, python)
    end

    return unless OS.linux?

    inreplace_files = prefix.glob("rml/CMakeFiles/irml.dir/{flags.make,build.make,link.txt}")
    inreplace inreplace_files, Superenv.shims_path/ENV.cxx, ENV.cxx
  end

  test do
    # The glob that installs these might fail,
    # so let's check their existence.
    assert_path_exists lib/"libtbb.a"
    assert_path_exists lib/"libtbbmalloc.a"

    (testpath/"sum1-100.cpp").write <<~EOS
      #include <iostream>
      #include <tbb/blocked_range.h>
      #include <tbb/parallel_reduce.h>

      int main()
      {
        auto total = tbb::parallel_reduce(
          tbb::blocked_range<int>(0, 100),
          0.0,
          [&](tbb::blocked_range<int> r, int running_total)
          {
            for (int i=r.begin(); i < r.end(); ++i) {
              running_total += i + 1;
            }

            return running_total;
          }, std::plus<int>()
        );

        std::cout << total << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "sum1-100.cpp", "--std=c++14", "-L#{lib}", "-ltbb", "-o", "sum1-100"
    assert_equal "5050", shell_output("./sum1-100").chomp

    system Formula["python@3.10"].opt_bin/"python3.10", "-c", "import tbb"
  end
end

__END__
diff --git a/python/CMakeLists.txt b/python/CMakeLists.txt
index 1d2b05f..81ba8de 100644
--- a/python/CMakeLists.txt
+++ b/python/CMakeLists.txt
@@ -49,7 +49,7 @@ add_test(NAME python_test
                  -DPYTHON_MODULE_BUILD_PATH=${PYTHON_BUILD_WORK_DIR}/build
                  -P ${PROJECT_SOURCE_DIR}/cmake/python/test_launcher.cmake)

-install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_BUILD_WORK_DIR}/build/
+install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_BUILD_WORK_DIR}/
         DESTINATION .
         COMPONENT tbb4py)
