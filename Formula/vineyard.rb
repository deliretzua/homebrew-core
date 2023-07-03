class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.15.3/v6d-0.15.3.tar.gz"
  sha256 "1e4de9b9840b5b3955c27f7126b75a049312ffb6f377381dcba787d5eb257456"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "b34767942e03993907f5604f2c4a8c8c130c08a81f52fbf942ebccda09e720d7"
    sha256                               arm64_monterey: "8e59d20d4da6fa309be1299b62edaec521abc7cf839190fabaab733b93b7502a"
    sha256                               arm64_big_sur:  "7cfab5f5476e5185f87876228c7d12dc5b28b8de78beb83dc2f5ea0544dd42e6"
    sha256                               ventura:        "736252be5f75c2651303e836354ce7095fc4c85665fffc79fc0a89687e20e2f0"
    sha256                               monterey:       "cb0e702f749af0c8277838c343e9031bdec6343bf5c6b03e4daef4dda61a309f"
    sha256                               big_sur:        "7a8d69bc10e61a6217d02a72a4ba8baf5c50e70905bf0f0eaff704e29356e682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3455821d8ff1a322fb1457adddcfcd7c4de1add524b67a73aaa1b32856c22b4f"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python@3.11" => :build
  depends_on "apache-arrow"
  depends_on "boost"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "libgrape-lite"
  depends_on "open-mpi"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "redis"

  fails_with gcc: "5"

  def install
    python = "python3.11"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{which(python)}",
                    "-DUSE_EXTERNAL_ETCD_LIBS=ON",
                    "-DUSE_EXTERNAL_REDIS_LIBS=ON",
                    "-DUSE_EXTERNAL_HIREDIS_LIBS=ON",
                    "-DBUILD_VINEYARD_TESTS=OFF",
                    "-DUSE_LIBUNWIND=OFF",
                    "-DLIBGRAPELITE_INCLUDE_DIRS=#{Formula["libgrape-lite"].opt_include}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <memory>

      #include <vineyard/client/client.h>

      int main(int argc, char **argv) {
        vineyard::Client client;
        VINEYARD_CHECK_OK(client.Connect(argv[1]));

        std::shared_ptr<vineyard::InstanceStatus> status;
        VINEYARD_CHECK_OK(client.InstanceStatus(status));
        std::cout << "vineyard instance is: " << status->instance_id << std::endl;

        return 0;
      }
    EOS

    system ENV.cxx, "test.cc", "-std=c++17",
                    "-I#{Formula["apache-arrow"].include}",
                    "-I#{Formula["boost"].include}",
                    "-I#{include}",
                    "-I#{include}/vineyard",
                    "-I#{include}/vineyard/contrib",
                    "-L#{Formula["apache-arrow"].lib}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{lib}",
                    "-larrow",
                    "-lboost_thread-mt",
                    "-lboost_system-mt",
                    "-lvineyard_client",
                    "-o", "test_vineyard_client"

    # prepare vineyardd
    vineyardd_pid = spawn bin/"vineyardd", "--norpc",
                                           "--meta=local",
                                           "--socket=#{testpath}/vineyard.sock"

    # sleep to let vineyardd get its wits about it
    sleep 10

    assert_equal("vineyard instance is: 0\n", shell_output("./test_vineyard_client #{testpath}/vineyard.sock"))
  ensure
    # clean up the vineyardd process before we leave
    Process.kill("HUP", vineyardd_pid)
  end
end
