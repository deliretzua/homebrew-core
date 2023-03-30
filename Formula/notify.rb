class Notify < Formula
  desc "Stream the output of any CLI and publish it to a variety of supported platforms"
  homepage "https://github.com/projectdiscovery/notify"
  url "https://github.com/projectdiscovery/notify/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "9fa8428b4e88da754c265b50a4ea61ee534857ad722c6d6c562362bb238ba1ed"
  license "MIT"
  head "https://github.com/projectdiscovery/notify.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/notify"
  end

  test do
    assert_match "Current Version: #{version}", shell_output("#{bin}/notify --version 2>&1")
    assert_predicate testpath/".config/notify/config.yaml", :exist?
  end
end
