class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "2ce064f61daa11326a89f10e7ffc52b5d9b68d25d54a5577c82d27904cfe8a23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f8c342827da10fe352cdc51089f1d95854d89938661d2122398a445bd19306c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f8c342827da10fe352cdc51089f1d95854d89938661d2122398a445bd19306c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f8c342827da10fe352cdc51089f1d95854d89938661d2122398a445bd19306c"
    sha256 cellar: :any_skip_relocation, ventura:        "3111b4b83266aed14bef40f0926ec6f78cfe9a2d78b2761adca9551d530bc1c0"
    sha256 cellar: :any_skip_relocation, monterey:       "3111b4b83266aed14bef40f0926ec6f78cfe9a2d78b2761adca9551d530bc1c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3111b4b83266aed14bef40f0926ec6f78cfe9a2d78b2761adca9551d530bc1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2992d6a2d1255b5de29adf69ade1e0646fb13684b5abe725ecdf264d1ed59229"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
