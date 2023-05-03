class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.18.tar.gz"
  sha256 "60348d4785be446b4cc32c293d4bdc943be176cb326e1bd17c7500c83ccf2bff"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cffa03e045c74c8785a59bf512148b5f1eecad7595e19e68bbe834c1e35dfaa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cffa03e045c74c8785a59bf512148b5f1eecad7595e19e68bbe834c1e35dfaa0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cffa03e045c74c8785a59bf512148b5f1eecad7595e19e68bbe834c1e35dfaa0"
    sha256 cellar: :any_skip_relocation, ventura:        "2de93e710e1174e624089b31701af1cf54545df3c0e857c5a42049ccc0f2e8b5"
    sha256 cellar: :any_skip_relocation, monterey:       "2de93e710e1174e624089b31701af1cf54545df3c0e857c5a42049ccc0f2e8b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2de93e710e1174e624089b31701af1cf54545df3c0e857c5a42049ccc0f2e8b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d7429ab262daf6e1eb5847952a8c65056811405a92bdfb7b18d345e2cb8d9d4"
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
