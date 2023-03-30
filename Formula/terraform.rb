class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.4.4.tar.gz"
  sha256 "ab9e6d743c0a00be8c6c1a2723f39191e3cbd14517acbc3e6ff2baa753865074"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07471f230d3111743627c8b2d5441b5923d34d86404779eb330fffbc097dcc6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07471f230d3111743627c8b2d5441b5923d34d86404779eb330fffbc097dcc6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07471f230d3111743627c8b2d5441b5923d34d86404779eb330fffbc097dcc6d"
    sha256 cellar: :any_skip_relocation, ventura:        "4d3edf7f7a6359d7cd8e806ed05d7c9a09832671d0e022ebced671e59393eab1"
    sha256 cellar: :any_skip_relocation, monterey:       "4d3edf7f7a6359d7cd8e806ed05d7c9a09832671d0e022ebced671e59393eab1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d3edf7f7a6359d7cd8e806ed05d7c9a09832671d0e022ebced671e59393eab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91b6219dc94c2853b8d0f536fd1b0892f94f61a604e660c6ada4bfe30e6aedf3"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
