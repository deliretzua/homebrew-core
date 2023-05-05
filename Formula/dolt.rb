class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.21.tar.gz"
  sha256 "df2af7ad02a9309df18eef3cdcdc532156eceb71650d8da61e043b18468321d4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b5f4ae685f38cf64c642b273b54a83f9b267ccd0f374be4f3544c74c6f7f0dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b5f4ae685f38cf64c642b273b54a83f9b267ccd0f374be4f3544c74c6f7f0dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b5f4ae685f38cf64c642b273b54a83f9b267ccd0f374be4f3544c74c6f7f0dc"
    sha256 cellar: :any_skip_relocation, ventura:        "bb3d870901d5d781758da8046819787c8b121e02ff2fe7bce294993ed98032a3"
    sha256 cellar: :any_skip_relocation, monterey:       "bb3d870901d5d781758da8046819787c8b121e02ff2fe7bce294993ed98032a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb3d870901d5d781758da8046819787c8b121e02ff2fe7bce294993ed98032a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40e9353ef82f7f28ec1a6fc9d933723d08d4638f8cfe9a4be0d7e25e5d3db55d"
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
