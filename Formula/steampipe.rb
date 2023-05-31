class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "20e1120a12976b627400d0bb7f5d85ed542ec1e5f55fc392d6c612014569ebef"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06a8e6e0469f5f2bc600c3625bb10de7f54e11861a83d6a829feaec35d273c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c65e4de955c115d80acff5200aff2bdd2ec31c78a3b7e7d4d29c66c1ee52b476"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d1af3cebb795285bb6392827bcf06fdbfeacf7d8d150c96b758be2d1e5bbd2d"
    sha256 cellar: :any_skip_relocation, ventura:        "bae0f89ba9fb3401d77809237b42aaf3d83d29801d72f627802acda142569ac2"
    sha256 cellar: :any_skip_relocation, monterey:       "15aeb90196bf7c0741d4369de6308c7b372df5bf068231d569350780bbf0e557"
    sha256 cellar: :any_skip_relocation, big_sur:        "52b0e419702d7aa3d9b2fe7aca1cd8d6b1d6b8be40fd5d65fac4b64fad92bcb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a671247cfc863a6f155f8ee5cf3275dd1a7e53bdda60fdc45aadfb828748434e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create installation directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
