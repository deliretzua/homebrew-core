class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "cac90e2683079d2fbe7c5e387d6a5acb65c7d340153df06e91578f9212def50b"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cb9b8023b6c92e3ad0f235c847fa2bfb4c92029cb1184d0d20ed071f97a69d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cb9b8023b6c92e3ad0f235c847fa2bfb4c92029cb1184d0d20ed071f97a69d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cb9b8023b6c92e3ad0f235c847fa2bfb4c92029cb1184d0d20ed071f97a69d1"
    sha256 cellar: :any_skip_relocation, ventura:        "b4df9275e6b7eff85d3d5078b305181697d4f05b867e6375b89dffa30bfc3534"
    sha256 cellar: :any_skip_relocation, monterey:       "b4df9275e6b7eff85d3d5078b305181697d4f05b867e6375b89dffa30bfc3534"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4df9275e6b7eff85d3d5078b305181697d4f05b867e6375b89dffa30bfc3534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9031c1bb2bc56b2f7fd6c1c6a8fda60247642c1413797bbaa884b2cd1a2c0fea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    EOS

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 packages
      No vulnerabilities found
    EOS
    assert_equal expected_output, scan_output
  end
end
