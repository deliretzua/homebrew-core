class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "https://source.wiredtiger.com/"
  url "https://github.com/wiredtiger/wiredtiger/archive/refs/tags/11.1.0.tar.gz"
  sha256 "0d988a8256219b614d855a2504d252975240171a633b882f19149c4a2ce0ec3d"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1d04f1bdbde31a61d9193d9d729692b73b94f6b6634c37267f0ef2a2758ba3ea"
    sha256 cellar: :any,                 arm64_monterey: "54ae003509c8488b6dbf019a88fad8215198e3e10ad120b4fb79fa87b33d2051"
    sha256 cellar: :any,                 arm64_big_sur:  "04f9b121ef62be4f365d36bc1e2c901bfafe37bf62580b701898c01a9b58d359"
    sha256 cellar: :any,                 ventura:        "82a8202fe03fe1b0588a7ea54c174b6091d3acec25fc0d8f876618bca115aab1"
    sha256 cellar: :any,                 monterey:       "bcf4fa0509021ae516a154281108eef2575616dcd0c16f1bc1937f0dc09e6f5a"
    sha256 cellar: :any,                 big_sur:        "ebaab842d86b6088ef042da0b73d23e7da494128916e5b16f17daa16e8cfc028"
    sha256 cellar: :any,                 catalina:       "ab75e49599d73c0537853750e440137ee2c07c8b027f6cf21c19dd8a3fb7644b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b01253492207235ce85d2e72773bfff7fb5a054978c11cdb00b428e921f5bd"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_linux do
    depends_on "python@3.11" => :build
  end

  # Adds include for std::optional. Remove in version 11.2.0.
  patch do
    url "https://github.com/wiredtiger/wiredtiger/commit/4418f9d2d7cad3829b47566d374ee73b29d699d7.patch?full_index=1"
    sha256 "79bc6c1f027cda7742cdca26b361471126c60e8e66198a8dae4782b2a750c1c3"
  end

  def install
    args = %W[
      -DHAVE_BUILTIN_EXTENSION_SNAPPY=1
      -DHAVE_BUILTIN_EXTENSION_ZLIB=1
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DCMAKE_C_FLAGS=-Wno-maybe-uninitialized" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/wt", "create", "table:test"
    system "#{bin}/wt", "drop", "table:test"
  end
end
