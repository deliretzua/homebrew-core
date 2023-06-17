class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.5.0.tar.gz"
  sha256 "da2b1c865fb20c9a74c036718338201d7bae44ef87c058168bb6a6b1475bc746"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3f14c7eadbb69d2cc9804fea0f39cec111cc9e00e928a6be874227e074c48f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f14c7eadbb69d2cc9804fea0f39cec111cc9e00e928a6be874227e074c48f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3f14c7eadbb69d2cc9804fea0f39cec111cc9e00e928a6be874227e074c48f2"
    sha256 cellar: :any_skip_relocation, ventura:        "afc7d1b08f4e88a6568223f5567c28889f213271abd9bdf7cc4febf144953697"
    sha256 cellar: :any_skip_relocation, monterey:       "afc7d1b08f4e88a6568223f5567c28889f213271abd9bdf7cc4febf144953697"
    sha256 cellar: :any_skip_relocation, big_sur:        "afc7d1b08f4e88a6568223f5567c28889f213271abd9bdf7cc4febf144953697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9fdcf99e5609261876f55000cd0e2b70b478e9c7dcd284dafafb59a753dec6a"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
