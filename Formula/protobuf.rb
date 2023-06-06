class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  license "BSD-3-Clause"

  # TODO: Remove `stable` block when patch is no longer needed.
  stable do
    url "https://github.com/protocolbuffers/protobuf/releases/download/v23.2/protobuf-23.2.tar.gz"
    sha256 "ddf8c9c1ffccb7e80afd183b3bd32b3b62f7cc54b106be190bf49f2bc09daab5"

    # Fix missing unexported symbols.
    # https://github.com/protocolbuffers/protobuf/issues/12932
    patch do
      url "https://github.com/protocolbuffers/protobuf/commit/fc1c5512e524e0c00a276aa9a38b2cdb8fdf45c7.patch?full_index=1"
      sha256 "2ef672ecc95e0b35e2ef455ebbbaaaf0d5a89a341b5bbbe541c6285dfca48508"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e969047bde848e06e3fc5ba173d3333dfd7ee98355ea6781ec2d88c1282cc89c"
    sha256 cellar: :any,                 arm64_monterey: "162ef2d8fee02efd112b446dc38e230174c23de201d8b0c2c3551a9121a9dde5"
    sha256 cellar: :any,                 arm64_big_sur:  "b3fb6b1f4c33c714e1ac76b2aa7376daaf53f5d169ccbb4397cacc356705870a"
    sha256 cellar: :any,                 ventura:        "e72244f822ab8b34f361e4f1d2ef555e3406a5511a054cc32b4a8ddd56cc2f2d"
    sha256 cellar: :any,                 monterey:       "bba0e37d3242957997deac64d658bf4b33ef94e9b9dee31eb14efc52b8323c0a"
    sha256 cellar: :any,                 big_sur:        "d305c1a139f5f3c1cd48e771aa6b322ea63fbfb3f2b1d361d0537d88a9eab5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c74f6a322b8e208c9bdee72732cc9de205e2de2e53dd1e0578d3306c56a21457"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git", branch: "main"
    depends_on "jsoncpp"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "abseil"
  # TODO: Add the dependency below in Protobuf 24+. Also remove `head` block.
  # TODO: depends_on "jsoncpp"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    odie "Dependencies need adjusting!" if build.stable? && version >= "24"
    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=OFF
      -Dprotobuf_ABSL_PROVIDER=package
      -Dprotobuf_JSONCPP_PROVIDER=package
    ]
    cmake_args << "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}"

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"
    ENV["PROTOC"] = bin/"protoc"

    cd "python" do
      # Keep C++ standard in sync with `abseil.rb`.
      inreplace "setup.py", "extra_compile_args.append('-std=c++14')",
                            "extra_compile_args.append('-std=c++#{abseil_cxx_standard}')"
      pythons.each do |python|
        pyext_dir = prefix/Language::Python.site_packages(python)/"google/protobuf/pyext"
        with_env(LDFLAGS: "-Wl,-rpath,#{rpath(source: pyext_dir)} #{ENV.ldflags}".strip) do
          system python, *Language::Python.setup_install_args(prefix, python), "--cpp_implementation"
        end
      end
    end
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."

    pythons.each do |python|
      system python, "-c", "from google.protobuf.pyext import _message"
    end
  end
end
