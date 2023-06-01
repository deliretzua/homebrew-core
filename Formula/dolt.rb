class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.2.3.tar.gz"
  sha256 "284b69fa83b5207ab4a7b7fa3c3c7003b22cc6a6cfa9c49093bb7dc9d8a27c66"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "160e704d5983584b703b3801fd48afc7a09f226ecdd4a67fbf8ed8aca9d0ea5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "160e704d5983584b703b3801fd48afc7a09f226ecdd4a67fbf8ed8aca9d0ea5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "160e704d5983584b703b3801fd48afc7a09f226ecdd4a67fbf8ed8aca9d0ea5b"
    sha256 cellar: :any_skip_relocation, ventura:        "6eadc550cb7bc861ad73a9681c7e1e4d46e799a8821a9c7d8c50927f514c0ef2"
    sha256 cellar: :any_skip_relocation, monterey:       "6eadc550cb7bc861ad73a9681c7e1e4d46e799a8821a9c7d8c50927f514c0ef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6eadc550cb7bc861ad73a9681c7e1e4d46e799a8821a9c7d8c50927f514c0ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8c41ad946df71e863c583a909fd211717127cc1aefbf2fcc07f2663f6f0b9c7"
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
