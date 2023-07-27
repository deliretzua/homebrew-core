class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.8.4.tar.gz"
  sha256 "75b0e74b21518249b196a6afb32949e9fa4497f0cf133c7b6aaa9f6e5fd0adb2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ea343d8232280ccc8bf0a297ae9a99b2874323f61d535e22e73fa1254266b70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ea343d8232280ccc8bf0a297ae9a99b2874323f61d535e22e73fa1254266b70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ea343d8232280ccc8bf0a297ae9a99b2874323f61d535e22e73fa1254266b70"
    sha256 cellar: :any_skip_relocation, ventura:        "4b87d0c0e32987270c5f44c4d5d43590b4bed3bcd6a927feb491b5f44a3823e5"
    sha256 cellar: :any_skip_relocation, monterey:       "4b87d0c0e32987270c5f44c4d5d43590b4bed3bcd6a927feb491b5f44a3823e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b87d0c0e32987270c5f44c4d5d43590b4bed3bcd6a927feb491b5f44a3823e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6587d53a3a4d5909a352c9da30dd990fb07c66679bc188eb68c841454c94242"
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
