class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "d065de300a1764077c31900e24e4843d5706eb397d787db0b3312d64c94f15a9"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  # The current version of `quic-go` dependency can only be built with `go@1.18`.
  # Try `go@1.19` or newer at next release; upstream has already upgraded `quic-go` at master branch.
  depends_on "go@1.18" => :build

  def install
    system "make", "build"
    bin.install "ipget"
  end

  test do
    # Make sure correct version is reported
    assert_match version.to_s, shell_output("#{bin}/ipget --version")

    # An example content identifier (CID) used in IPFS docs:
    # https://docs.ipfs.tech/concepts/content-addressing/
    cid = "bafybeihkoviema7g3gxyt6la7vd5ho32ictqbilu3wnlo3rs7ewhnp7lly"
    system "#{bin}/ipget", "ipfs://#{cid}/"
    assert_match "JPEG image data", shell_output("file #{cid}")
  end
end
