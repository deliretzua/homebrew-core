class Libtensorflow < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "4b487a63d6f0c1ca46a2ac37ba4687eabdc3a260c222616fa414f6df73228cec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "2dadb06decc617dccdebf2c705392383da5ebf5364a2ac54d8578482ccb8a1d1"
    sha256 cellar: :any, arm64_big_sur:  "957a598e6f28edd0d75d3f33dc59d61402da2fe8e1a41e15c8ebfeed18c7c31a"
    sha256 cellar: :any, monterey:       "982a55d966f26a5d835f3c92b0872afe081f152c638965f21fdb9a5d00004a66"
    sha256 cellar: :any, big_sur:        "2347f7790244986949de0e894bb657ea0d92d0bf413c7fad19a341cba1166f93"
    sha256 cellar: :any, catalina:       "bf001c3dc6f61aa693d22c6c9622c6c814e69a9a7f00698acb7c1a203a2b0fdc"
  end

  depends_on "bazelisk" => :build
  depends_on "numpy" => :build
  depends_on "python@3.10" => :build

  resource "test-model" do
    url "https://github.com/tensorflow/models/raw/v1.13.0/samples/languages/java/training/model/graph.pb"
    sha256 "147fab50ddc945972818516418942157de5e7053d4b67e7fca0b0ada16733ecb"
  end

  # Fix build for host without python2
  # Remove in the next 2.9 release
  patch do
    url "https://github.com/tensorflow/tensorflow/commit/1dd61c1f744227ad2434a7a9813fc57f623bc9a2.patch?full_index=1"
    sha256 "f73a590f19962c097251efa6f4f40b80dfa944e3440b298973436016aea67c70"
  end
  patch do
    url "https://github.com/tensorflow/tensorflow/commit/739002567ff81d731179a4b949def7e0f14737c8.patch?full_index=1"
    sha256 "23c96cf491a6445db18353504bdb0b01f58770f1c0da405da42b91381259ce0e"
  end

  def install
    optflag = if Hardware::CPU.arm? && OS.mac?
      "-mcpu=apple-m1"
    elsif build.bottle?
      "-march=#{Hardware.oldest_cpu}"
    else
      "-march=native"
    end
    ENV["CC_OPT_FLAGS"] = optflag
    ENV["PYTHON_BIN_PATH"] = Formula["python@3.10"].opt_bin/"python3"
    ENV["TF_IGNORE_MAX_BAZEL_VERSION"] = "1"
    ENV["TF_NEED_JEMALLOC"] = "1"
    ENV["TF_NEED_GCP"] = "0"
    ENV["TF_NEED_HDFS"] = "0"
    ENV["TF_ENABLE_XLA"] = "0"
    ENV["USE_DEFAULT_PYTHON_LIB_PATH"] = "1"
    ENV["TF_NEED_OPENCL"] = "0"
    ENV["TF_NEED_CUDA"] = "0"
    ENV["TF_NEED_MKL"] = "0"
    ENV["TF_NEED_VERBS"] = "0"
    ENV["TF_NEED_MPI"] = "0"
    ENV["TF_NEED_S3"] = "1"
    ENV["TF_NEED_GDR"] = "0"
    ENV["TF_NEED_KAFKA"] = "0"
    ENV["TF_NEED_OPENCL_SYCL"] = "0"
    ENV["TF_NEED_ROCM"] = "0"
    ENV["TF_DOWNLOAD_CLANG"] = "0"
    ENV["TF_SET_ANDROID_WORKSPACE"] = "0"
    ENV["TF_CONFIGURE_IOS"] = "0"
    system "./configure"

    bazel_args = %W[
      --jobs=#{ENV.make_jobs}
      --compilation_mode=opt
      --copt=#{optflag}
      --linkopt=-Wl,-rpath,#{rpath}
      --verbose_failures
    ]
    targets = %w[
      tensorflow:libtensorflow.so
      tensorflow:install_headers
      tensorflow/tools/benchmark:benchmark_model
      tensorflow/tools/graph_transforms:summarize_graph
      tensorflow/tools/graph_transforms:transform_graph
    ]
    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *bazel_args, *targets

    lib.install Dir["bazel-bin/tensorflow/*.so*", "bazel-bin/tensorflow/*.dylib*"]
    include.install "bazel-bin/tensorflow/include/tensorflow"
    bin.install %w[
      bazel-bin/tensorflow/tools/benchmark/benchmark_model
      bazel-bin/tensorflow/tools/graph_transforms/summarize_graph
      bazel-bin/tensorflow/tools/graph_transforms/transform_graph
    ]

    (lib/"pkgconfig/tensorflow.pc").write <<~EOS
      Name: tensorflow
      Description: Tensorflow library
      Version: #{version}
      Libs: -L#{lib} -ltensorflow
      Cflags: -I#{include}
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <tensorflow/c/c_api.h>
      int main() {
        printf("%s", TF_Version());
      }
    EOS
    system ENV.cc, "-L#{lib}", "-ltensorflow", "-o", "test_tf", "test.c"
    assert_equal version, shell_output("./test_tf")

    resource("test-model").stage(testpath)

    summarize_graph_output = shell_output("#{bin}/summarize_graph --in_graph=#{testpath}/graph.pb 2>&1")
    variables_match = /Found \d+ variables:.+$/.match(summarize_graph_output)
    refute_nil variables_match, "Unexpected stdout from summarize_graph for graph.pb (no found variables)"
    variables_names = variables_match[0].scan(/name=([^,]+)/).flatten.sort

    transform_command = %W[
      #{bin}/transform_graph
      --in_graph=#{testpath}/graph.pb
      --out_graph=#{testpath}/graph-new.pb
      --inputs=n/a
      --outputs=n/a
      --transforms="obfuscate_names"
      2>&1
    ].join(" ")
    shell_output(transform_command)

    assert_predicate testpath/"graph-new.pb", :exist?, "transform_graph did not create an output graph"

    new_summarize_graph_output = shell_output("#{bin}/summarize_graph --in_graph=#{testpath}/graph-new.pb 2>&1")
    new_variables_match = /Found \d+ variables:.+$/.match(new_summarize_graph_output)
    refute_nil new_variables_match, "Unexpected summarize_graph output for graph-new.pb (no found variables)"
    new_variables_names = new_variables_match[0].scan(/name=([^,]+)/).flatten.sort

    refute_equal variables_names, new_variables_names, "transform_graph didn't obfuscate variable names"

    benchmark_model_match = /benchmark_model -- (.+)$/.match(new_summarize_graph_output)
    refute_nil benchmark_model_match,
      "Unexpected summarize_graph output for graph-new.pb (no benchmark_model example)"

    benchmark_model_args = benchmark_model_match[1].split
    benchmark_model_args.delete("--show_flops")

    benchmark_model_command = [
      "#{bin}/benchmark_model",
      "--time_limit=10",
      "--num_threads=1",
      *benchmark_model_args,
      "2>&1",
    ].join(" ")

    assert_includes shell_output(benchmark_model_command),
      "Timings (microseconds):",
      "Unexpected benchmark_model output (no timings)"
  end
end
