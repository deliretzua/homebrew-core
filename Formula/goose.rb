class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/v3.13.0.tar.gz"
  sha256 "5c5d7ce17a5436a1878ad864d2d961391f388494b012756bfc2104ac02070ab7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa669d97cb91d606d80113bf32cb363894b3e6f2261923ea70c397e672776744"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18c23e3023147d8c4f1d01047f9d9a34e66d36bb9d8c0927f0e95e235ba4bb3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9f8b60b15b0b54ed582b44c82ccee306a769a3527d085fa5268fa8564a313ee"
    sha256 cellar: :any_skip_relocation, ventura:        "ba0e6ab062d312ebbdba3b0771a2b598bc30d1c2fbce01389ee4934736633c66"
    sha256 cellar: :any_skip_relocation, monterey:       "26605a99af8cd7335f9d13f6d5b3b29b41763f0eb7f96a3e3ec2d232deed69fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f184f7bb261d13ec61e050825764be0ad9c95c79cb0341052c2ada65267076c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4089db254656f10489eb742662bf0faadc7fc03e19c6259c12611e89e05c653c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
