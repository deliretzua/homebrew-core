class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.15.9.tar.gz"
  sha256 "87b3cd1631388f65a09b02e549f34fdacdfa34a3cb7e6c7283876402a75d5d3e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84e3780b88d19796a2bc41e69a5074c474f0c1865ac042ce7327bd8bec577037"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85a927772c320abc8038f704bde6df756bed250754a54d42ea3d0b4ccaba60ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3025d0bf06a59c4fecbcb9607bb0b67130397f806f1af7196e432b4f84e8ec8"
    sha256 cellar: :any_skip_relocation, ventura:        "6d8de45144cc71f775fc67dfb0e61275e72ff8257bb0e58829b9de94d1bb9c1d"
    sha256 cellar: :any_skip_relocation, monterey:       "eea93447a734ff559545bb46c6f14ca6ba1f9cec0d1a4efc764bda9145445b3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9794647217624016388acbe51d986c790a6d4b5cdf715766ebf7470cae2be1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1960ef108d832d6890b17a58ebe74d94cf460a0cabaeb57150c308468bdf5bb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
