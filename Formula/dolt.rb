class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.3.0.tar.gz"
  sha256 "db26812fe1e93df62dc02eefe1083dc94ce8ace368cba4412c8c51079e707e7f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fce1cadb2d923b6abe4c52527493e10cb4c41e65d8d72f1dd97bba60d23aeaf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fce1cadb2d923b6abe4c52527493e10cb4c41e65d8d72f1dd97bba60d23aeaf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fce1cadb2d923b6abe4c52527493e10cb4c41e65d8d72f1dd97bba60d23aeaf8"
    sha256 cellar: :any_skip_relocation, ventura:        "503e188a9d85ce34b1889cfc864323bb68f128cc8d20fa9605a339a601ad533c"
    sha256 cellar: :any_skip_relocation, monterey:       "503e188a9d85ce34b1889cfc864323bb68f128cc8d20fa9605a339a601ad533c"
    sha256 cellar: :any_skip_relocation, big_sur:        "503e188a9d85ce34b1889cfc864323bb68f128cc8d20fa9605a339a601ad533c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9083102489930dea83ed866f042e2c2e88841f90ce0dd6913f5a0796b26a16b8"
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
