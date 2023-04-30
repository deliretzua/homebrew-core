class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.1.4.tar.gz"
  sha256 "7c0868cb27f904ab8e158881cf4862a15f216122a43525d2ea93a1aa7bf03cff"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b656a37bd64c1aa17ebbee03c40cf7e567a1640708f365242360440295d18ba3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b656a37bd64c1aa17ebbee03c40cf7e567a1640708f365242360440295d18ba3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b656a37bd64c1aa17ebbee03c40cf7e567a1640708f365242360440295d18ba3"
    sha256 cellar: :any_skip_relocation, ventura:        "4d41571e2a6fb13204322585ea49aaea6452764037665fa6ec3f05bc84ce13e0"
    sha256 cellar: :any_skip_relocation, monterey:       "4d41571e2a6fb13204322585ea49aaea6452764037665fa6ec3f05bc84ce13e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d41571e2a6fb13204322585ea49aaea6452764037665fa6ec3f05bc84ce13e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24fd88c5f4e51ff7a15a3a87ff7cdfcb0d0aab72d50058e4b5d60df9845c2848"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
