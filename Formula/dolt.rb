class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.19.tar.gz"
  sha256 "d714c769e13801a677c39f8a037f59f9276fa7676eccb7f06227c3fa8669c6f2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7c4126871680ed583b032a70a06ce84ff431107112cf0ee45a52d1545f7f6e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7c4126871680ed583b032a70a06ce84ff431107112cf0ee45a52d1545f7f6e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7c4126871680ed583b032a70a06ce84ff431107112cf0ee45a52d1545f7f6e3"
    sha256 cellar: :any_skip_relocation, ventura:        "0543e192b358ed952eca2c8cf32c20d6e7de8d802edf5e6e465eb45e8305442e"
    sha256 cellar: :any_skip_relocation, monterey:       "0543e192b358ed952eca2c8cf32c20d6e7de8d802edf5e6e465eb45e8305442e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0543e192b358ed952eca2c8cf32c20d6e7de8d802edf5e6e465eb45e8305442e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0966a78624b2180e98581fdfc775404e5dde9600cd376b54baf88858df6f0e49"
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
