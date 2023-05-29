class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/mozilla/cbindgen"
  url "https://github.com/mozilla/cbindgen/archive/refs/tags/v0.24.5.tar.gz"
  sha256 "0ae34b7b4fb7186407ad3eed9783a48135a7ca3f8f9e3c2966483df44815e0ac"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8701a4777cdc4478d935bcf9ad523d5f3415588d1e989b562659ae7fb6cf6eb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80afabe544aa9dfab277af2d727d045ebfc9870528e4a827130dd6d4a79d8d8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed3c8e486ca6a066f52b7a46ae121b801f09b32481f5808cbe9c28ca8d79b01b"
    sha256 cellar: :any_skip_relocation, ventura:        "d6449d51d30926c6b3f7eae252c077ce1f9fe875aa0d7faee2fca8b0a6e73f45"
    sha256 cellar: :any_skip_relocation, monterey:       "06a3a8dc1ed2d826af80b44d7599b954f81c49d4b3f155bd413a02ebb4b1b495"
    sha256 cellar: :any_skip_relocation, big_sur:        "e117f2e823e930f4b76aff6399104641edcb10750259bceb6be04bef16914586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86ef1a5238cabd9309b31bc933fd9b39d3b5a300e4f04c6d2299000018098963"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/rust/extern.rs", testpath
    output = shell_output("#{bin}/cbindgen extern.rs")
    assert_match "extern int32_t foo()", output
  end
end
