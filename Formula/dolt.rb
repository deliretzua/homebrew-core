class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.14.tar.gz"
  sha256 "52d12cf87f6d456c03835a78393e308ebe27d8f85f802b9e2c482367afe8cc26"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4c1eee7aa6f91090330f8f7d7709a01d6a76e1670cecf98100b3150f5d9f5f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4c1eee7aa6f91090330f8f7d7709a01d6a76e1670cecf98100b3150f5d9f5f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4c1eee7aa6f91090330f8f7d7709a01d6a76e1670cecf98100b3150f5d9f5f4"
    sha256 cellar: :any_skip_relocation, ventura:        "fce49e04d9e77c5eb61ca8babc5354162b88370edde9f6f216ddd79b849bf113"
    sha256 cellar: :any_skip_relocation, monterey:       "fce49e04d9e77c5eb61ca8babc5354162b88370edde9f6f216ddd79b849bf113"
    sha256 cellar: :any_skip_relocation, big_sur:        "fce49e04d9e77c5eb61ca8babc5354162b88370edde9f6f216ddd79b849bf113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf95c71bd42f0751cd2a6c0dd1fde89af9848e50e7a576ef415d599fadc4707a"
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
