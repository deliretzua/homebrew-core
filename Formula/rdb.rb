class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "7b123989ea855ffc8e11220d45d0705e385e13079165626a634bc6572dc12827"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d173a7f5ccedfc4061950cb7d08b194c6c9cd24976c1fea14f3cbfbab1afab50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d173a7f5ccedfc4061950cb7d08b194c6c9cd24976c1fea14f3cbfbab1afab50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d173a7f5ccedfc4061950cb7d08b194c6c9cd24976c1fea14f3cbfbab1afab50"
    sha256 cellar: :any_skip_relocation, ventura:        "827ebc2bc1c7066f770f7358276391c95f2dfdc3fdebf5bef5f406c4df6fb52c"
    sha256 cellar: :any_skip_relocation, monterey:       "827ebc2bc1c7066f770f7358276391c95f2dfdc3fdebf5bef5f406c4df6fb52c"
    sha256 cellar: :any_skip_relocation, big_sur:        "827ebc2bc1c7066f770f7358276391c95f2dfdc3fdebf5bef5f406c4df6fb52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bd163cebaef6f22f648f5018514895d4db495e16af42373abbaf4a99b6690e0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    pkgshare.install "cases"
  end

  test do
    cp_r pkgshare/"cases", testpath
    system bin/"rdb", "-c", "memory", "-o", testpath/"mem1.csv", testpath/"cases/memory.rdb"
    assert_match "0,hash,hash,131,131B,2,ziplist,", (testpath/"mem1.csv").read
  end
end
