class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.5.tar.gz"
  sha256 "8b8dfd95e997878533116b71716eb749434f10fa3ade549f887c451d59fb804c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "24b425fd8373ed2f1cb2c665605353a0b9bf9579f0f179ef10f8b93264e41bcd"
    sha256 cellar: :any_skip_relocation, catalina: "d282186182f3c8f4c45682e497a4cb3eeba0622798bd61609fee68ea6decdef0"
    sha256 cellar: :any_skip_relocation, mojave:   "dc96ab9df182d3d944124082bfc997c7206178897d89b48b7c5e3f60992a7acb"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
