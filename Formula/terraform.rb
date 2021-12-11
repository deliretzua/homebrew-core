class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.1.0.tar.gz"
  sha256 "ecd3c4cfdcc01969c4f2d4a2cdf1911bb7bad56e5a7de11212c27b58919dfe91"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3385bd14a3478ecdf0c3fe9b0ccdda8dd0c267c4c6b2675bb4630d28ffbb1742"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad657418a000b368547071aefad3ae66fd106af6f31d16c7876a554f02dd9f06"
    sha256 cellar: :any_skip_relocation, monterey:       "bd79cea1b6c8ae6d4a661abe297d9801a3147c9a01b295cffb2a3420413221b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "67bf9cb6aebfbb23659af774c3604a6f5f26faa1884742439d95e30d7b74ab29"
    sha256 cellar: :any_skip_relocation, catalina:       "b9859560fe1dce5ebe6b996b72ff8eec4103afb811f52c4a4b11b65bff3bad0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db30312bb4e91a940f500ce5b21656e96634fee51b08a43517274ab250388ca4"
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
