class Cloudpan189Go < Formula
  desc "Command-line client tool for Cloud189 web disk"
  homepage "https://github.com/tickstep/cloudpan189-go"
  url "https://github.com/tickstep/cloudpan189-go/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "a215b75369af535aed214c94b66ebb3239b6ef5fcbc2f74039cf9c3eda4b04c1"
  license "Apache-2.0"
  head "https://github.com/tickstep/cloudpan189-go.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"cloudpan189-go", "run", "touch", "output.txt"
    assert_predicate testpath/"output.txt", :exist?
  end
end
