class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b6cf28228cfc509a021a88fd5aac35ba784bbe7c8119a4501773d7e5cb5c4a7f"
  license "MPL-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3680bb0f7514ab38441b4a7086a751e286d7fd411fa8a9cd6327d2caf225a55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3680bb0f7514ab38441b4a7086a751e286d7fd411fa8a9cd6327d2caf225a55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3680bb0f7514ab38441b4a7086a751e286d7fd411fa8a9cd6327d2caf225a55"
    sha256 cellar: :any_skip_relocation, ventura:        "a81c82cf7b72e895e507ad4d78ffcba4c348de94382494462ee80e5141703227"
    sha256 cellar: :any_skip_relocation, monterey:       "a81c82cf7b72e895e507ad4d78ffcba4c348de94382494462ee80e5141703227"
    sha256 cellar: :any_skip_relocation, big_sur:        "a81c82cf7b72e895e507ad4d78ffcba4c348de94382494462ee80e5141703227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6bdf1c2b5b1f2c5cc8211f3ccbedb8233d76681d5edc19d80fc64b9a528c85a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
