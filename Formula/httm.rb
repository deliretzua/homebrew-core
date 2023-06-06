class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.28.0.tar.gz"
  sha256 "a50efc82d914ab2db08b980181aa419f6d664509c6dbc242fbbe575c00e735bb"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97fe52a3052cec4897f6e662380017e568dc7b094f8abb67142c986e800aa77c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3e32fc0cfbf448040a50e8e26a6ab6220382ecb0cbffa20da3bae69db3362ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1dddcd0f52112c3d2df048f95a0f03fbed58a506fbb3d3585ac94b7f6284007"
    sha256 cellar: :any_skip_relocation, ventura:        "523509988f8358c4e2ba7d8c29b7f28e9432de9bd165a6b65eaffe6eb93f77e5"
    sha256 cellar: :any_skip_relocation, monterey:       "51e3c9a561fa5aafff1230e5f403dc58e3759aaa3de290188e00a20433cfd940"
    sha256 cellar: :any_skip_relocation, big_sur:        "544c38124ec950f640d4d8fab29164379677730610e34b254c3d5bf432ff14e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fb3e2ee7322bf16b8512681b8d554b6932997a6352e712ab55f1a6a466f4e25"
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
