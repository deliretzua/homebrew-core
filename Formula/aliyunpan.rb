class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.2.7-1.tar.gz"
  sha256 "25ecc26b0212594cff485bbe878faf05831feb5165bdde355513f558bb2f4b88"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_predicate testpath/"output.txt", :exist?
  end
end
