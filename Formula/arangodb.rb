class Arangodb < Formula
  desc "Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.10.3.tar.bz2"
  sha256 "9c47305451e6ccb9386416245986011fad8b9da3b61cd35bbeb15ee1e3806e66"
  license "Apache-2.0"
  head "https://github.com/arangodb/arangodb.git", branch: "devel"

  livecheck do
    url "https://www.arangodb.com/download-major/source/"
    regex(/href=.*?ArangoDB[._-]v?(\d+(?:\.\d+)+)(-\d+)?\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "196ca03c949389022a3c0d84606189e0185cb5698583d4be734780d335dee3b0"
    sha256 arm64_monterey: "36b2aafbb61710ebb88c34c7b2cc1951f6d88b9ec4ab9592db875e9ada9dd3d8"
    sha256 arm64_big_sur:  "63abcc969e399950b7f286b2fad2dde7885211b3862463edeedc6ac0c89ec8f3"
    sha256 ventura:        "582d958d19d17aecb12ec327b40792243d5555a92f886ed18746a71218c5843a"
    sha256 monterey:       "480235fa3dc1f1cb324c727b1e6b66faedb09bbae34fdbfd17225c6c4eec1612"
    sha256 big_sur:        "3e71951d623a9a24f93e18714562aef02ef919f9b615d8a88ea4e0f608141aa4"
    sha256 x86_64_linux:   "f618d6fb6481c8c5053d8a68b64f015a4a166be574ab12de0a38e7270ea8a82d"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "python@3.11" => :build
  depends_on macos: :mojave
  depends_on "openssl@1.1"

  on_macos do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "gcc@10" => :build
  end

  fails_with :clang do
    cause <<-EOS
      .../arangod/IResearch/AqlHelper.h:563:40: error: no matching constructor
      for initialization of 'std::string_view' (aka 'basic_string_view<char>')
              std::forward<Visitor>(visitor)(std::string_view{prev, begin});
                                             ^               ~~~~~~~~~~~~~
    EOS
  end

  # https://github.com/arangodb/arangodb/issues/17454
  # https://github.com/arangodb/arangodb/issues/17454
  fails_with gcc: "11"

  # https://www.arangodb.com/docs/stable/installation-compiling-debian.html
  fails_with :gcc do
    version "8"
    cause "requires at least g++ 9.2 as compiler since v3.7"
  end

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb.git",
        tag:      "0.15.6",
        revision: "6eaf220a66662125ccb27d3df9289d526b80109c"
  end

  def install
    if OS.mac?
      ENV.llvm_clang
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      # Fix building bundled boost with newer LLVM by avoiding removed `std::unary_function`.
      # .../boost/1.78.0/boost/container_hash/hash.hpp:132:33: error: no template named
      # 'unary_function' in namespace 'std'; did you mean '__unary_function'?
      ENV.append "CXXFLAGS", "-DBOOST_NO_CXX98_FUNCTION_BASE=1"
    end

    resource("starter").stage do
      ldflags = %W[
        -s -w
        -X main.projectVersion=#{resource("starter").version}
        -X main.projectBuild=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    arch = if Hardware::CPU.arm?
      "neon"
    elsif !build.bottle?
      # Allow local source builds to optimize for host hardware.
      # We don't set this on ARM since auto-detection isn't supported.
      "auto"
    elsif Hardware.oldest_cpu == :core2
      # Closest options to Homebrew's core2 are `core`, `merom`, and `penryn`.
      # `core` only enables up to SSE3 so we use `merom` which enables up to SSSE3.
      # As -march=merom doesn't exist in GCC/LLVM, build will fall back to -march=core2
      "merom"
    else
      Hardware.oldest_cpu
    end

    args = std_cmake_args + %W[
      -DHOMEBREW=ON
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
      -DTARGET_ARCHITECTURE=#{arch}
      -DUSE_GOOGLE_TESTS=OFF
      -DUSE_JEMALLOC=OFF
      -DUSE_MAINTAINER_MODE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"lib/arangodb3").mkpath
    (var/"log/arangodb3").mkpath
  end

  def caveats
    <<~EOS
      An empty password has been set. Please change it by executing
        #{opt_sbin}/arango-secure-installation
    EOS
  end

  service do
    run opt_sbin/"arangod"
    keep_alive true
  end

  test do
    require "pty"

    testcase = "require('@arangodb').print('it works!')"
    output = shell_output("#{bin}/arangosh --server.password \"\" --javascript.execute-string \"#{testcase}\"")
    assert_equal "it works!", output.chomp

    ohai "#{bin}/arangodb --starter.instance-up-timeout 1m --starter.mode single"
    PTY.spawn("#{bin}/arangodb", "--starter.instance-up-timeout", "1m",
              "--starter.mode", "single", "--starter.disable-ipv6",
              "--server.arangod", "#{sbin}/arangod",
              "--server.js-dir", "#{share}/arangodb3/js") do |r, _, pid|
      loop do
        available = r.wait_readable(60)
        refute_equal available, nil

        line = r.readline.strip
        ohai line

        break if line.include?("Your single server can now be accessed")
      end
    ensure
      Process.kill "SIGINT", pid
      ohai "shutting down #{pid}"
    end
  end
end
