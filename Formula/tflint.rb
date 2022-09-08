class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.40.0.tar.gz"
  sha256 "0ea93cb2c3cee6212dc2b12d2a462c25c498098bd2baf50a74bea77d5cd74f2d"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc7e474d690b1ec25b41b60ed49ad5a0ebd4be5927497a3d5fb7a0c172d5a3fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98eeab8b1c12b4f01b6b03f9ceff2edf4152ec73787fc5b0dceb1140a2a8cac7"
    sha256 cellar: :any_skip_relocation, monterey:       "cb51d0103aa72abb68f797c40fe08bbb6a64d703801c18d2794cf756cfa2f78f"
    sha256 cellar: :any_skip_relocation, big_sur:        "68040d50f1b7c4112042e52b05b22bbe1fa6b6a980c8bb8dcaa28c2c4185f6be"
    sha256 cellar: :any_skip_relocation, catalina:       "0d146db52f865c2b9e0a7138d20286a157c0f0ad2612230dd232fcce48aa813e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac8a30f692c5e181c403eac8f14d9027941ced13b4824a251c6899d37e54ac63"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      terraform {
        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 4"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
