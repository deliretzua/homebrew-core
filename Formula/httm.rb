class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.28.0.tar.gz"
  sha256 "a50efc82d914ab2db08b980181aa419f6d664509c6dbc242fbbe575c00e735bb"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21dc8e8043f22117ef1b92ca3ea13e7961563e83c453da6560ea287eb46d81ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9d5889b8416b0fe1dcace24f883198b8f832b981e317d7a55f3e95dfcab7766"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7a7961c1ed9eb9be3d949f464a49ff984b0c55e8048ac4b2821de78b207e723"
    sha256 cellar: :any_skip_relocation, ventura:        "6576b160fbd9cc6f10207d5b1b8746d74bd80a821da86068060176abe105057f"
    sha256 cellar: :any_skip_relocation, monterey:       "f4a481b2745aee29ff02784e323dd64ba0d234fe642a2b8d1deabdf713eb5c9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1774e99425dbbbeb02fd78de445eeefddd8a83353a89262d9f295fcbd09c6699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71661124ef999c7e36ccca5e2e1f671fcda5cc53462227d3f52b9b7923e35e9"
  end

  depends_on "rust" => :build

  # fix version config, remove in next release
  # upstream PR ref, https://github.com/kimono-koans/httm/pull/80
  patch do
    url "https://github.com/kimono-koans/httm/commit/ecb98af057b52148f11073df4b99237d67571672.patch?full_index=1"
    sha256 "cab499a3c6994323af6b1a27aa2bd8a5cdff4ce4c3fdea639675c5fad9e6ad5f"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
