class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.20.tar.gz"
  sha256 "4ca29924e26261f1081eaf12946f705c98531e3883f3227172fc6349a45fcb05"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0348f300bad9b3db87117ffaa96f2c423392426b07823469403b53ea7a04fc8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0348f300bad9b3db87117ffaa96f2c423392426b07823469403b53ea7a04fc8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0348f300bad9b3db87117ffaa96f2c423392426b07823469403b53ea7a04fc8b"
    sha256 cellar: :any_skip_relocation, ventura:        "a697c940deef480cbec5a4241d1422bc55217687a4da3884cb87ce1821b6b44f"
    sha256 cellar: :any_skip_relocation, monterey:       "a697c940deef480cbec5a4241d1422bc55217687a4da3884cb87ce1821b6b44f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a697c940deef480cbec5a4241d1422bc55217687a4da3884cb87ce1821b6b44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0245758f9b21276f85486964dd8f46735472d0bfc35912a51f6fd4ea9720efc"
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
