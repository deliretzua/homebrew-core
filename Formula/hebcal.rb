class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.7.1.tar.gz"
  sha256 "9dc2ca6d0c2aca82c99778bc6f762f9bd19ac4dd2a0ef15597a8da323d8c8c8a"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2de63fe840bda94bec04c3b7c03ce39754a01db4cca2e8bdc42b20c46082708f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2de63fe840bda94bec04c3b7c03ce39754a01db4cca2e8bdc42b20c46082708f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2de63fe840bda94bec04c3b7c03ce39754a01db4cca2e8bdc42b20c46082708f"
    sha256 cellar: :any_skip_relocation, ventura:        "2f1b1c71f887e6b57985daff0711aba66317cdb219785ffd90defc27857bff20"
    sha256 cellar: :any_skip_relocation, monterey:       "2f1b1c71f887e6b57985daff0711aba66317cdb219785ffd90defc27857bff20"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f1b1c71f887e6b57985daff0711aba66317cdb219785ffd90defc27857bff20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02537284c0ae770ca57d6c6316da736156c1c121ab2a79f52df8c4959d252325"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
