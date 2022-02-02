class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.1.5.tar.gz"
  sha256 "9c8de6905cb70aecd76a659e915bad7f2f7aa4dc3da0b8aea681b62885381a2f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89942aadb2afced3c2f4c66cd788c03b34d8ca7cdb28f3e67b641a7ac471c2c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "844ae60f1189f11e00a81a239f472c7c505838f968d18ce35bf795b7d68bd1ee"
    sha256 cellar: :any_skip_relocation, monterey:       "7e5489587740123be70acf0b7c96d5babfae8813095a6454c2135bc416fcf6d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "246de3b3f4648c830059ecc41652aa001a0e06b85a65ffc13c1a9ee3db0d7b45"
    sha256 cellar: :any_skip_relocation, catalina:       "6dd40c76dbe20da6bfcce441085c87f06712656217a1e9a900f1299781d42e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9c2d483b5f06d1fcf2b9a3320161cf4fb1127fe38a7f20d7ad4a8355aca5e9"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    # resolves issues fetching providers while on a VPN that uses /etc/resolv.conf
    # https://github.com/hashicorp/terraform/issues/26532#issuecomment-720570774
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~EOS
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    EOS
    system "#{bin}/terraform", "init"
    system "#{bin}/terraform", "graph"
  end
end
