class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.8.1.tar.gz"
  sha256 "5f5635277cf3f174e4da5ca92614bef8dce53542316b555a5186d2d77ba81fe7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d78157c2be52b17da7985fd13a9533bbbeaad36e0feca32718d176b18a10833c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d78157c2be52b17da7985fd13a9533bbbeaad36e0feca32718d176b18a10833c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d78157c2be52b17da7985fd13a9533bbbeaad36e0feca32718d176b18a10833c"
    sha256 cellar: :any_skip_relocation, ventura:        "db7daf06e9815c3539ec66a1725aa84d7b62b6ed456bddcf027d34163732fa99"
    sha256 cellar: :any_skip_relocation, monterey:       "db7daf06e9815c3539ec66a1725aa84d7b62b6ed456bddcf027d34163732fa99"
    sha256 cellar: :any_skip_relocation, big_sur:        "db7daf06e9815c3539ec66a1725aa84d7b62b6ed456bddcf027d34163732fa99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6306ce47f7885e36a6c99527337bcfc1740792ee35e3e857b35af00f898e4bba"
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
