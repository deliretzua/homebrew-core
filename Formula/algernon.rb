class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "f4be533e0d030d9f84ad4d0ebc22151f816e7e8a8418718f245694ff71a27f6a"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b2494fd9e642b337ab13dcb12857ca081ccd35a1013dc5fd7c3ce9f4ef38201"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ec5df7efb2dfdd48330d0fa0e623712bb9e7732a9299682a7415710c6e0424d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25a4376620fd94659d1f5c764014872b4b636ed73df3bce60d1e1390444d60b7"
    sha256 cellar: :any_skip_relocation, ventura:        "4f701b6ab0a3788159ffceb0d6a72fedbd7837771059f761df389a8907f23e6a"
    sha256 cellar: :any_skip_relocation, monterey:       "703600ef005e236eecee78ecab48a1d1f0ee7728783d86c1104378428705beb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a73076e60f90b23057b31092c8f8b88a845b46bec36c995f6deaaaf25fd5a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b184f747532e43eecba31c2edf1f430664b3169ba1c8124117d99e4497ee743b"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/xyproto/algernon/commit/00f29f8bcd0da772041a96fa9b57f7e1e21a6654
  # Remove on next release.
  depends_on "go@1.19" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
