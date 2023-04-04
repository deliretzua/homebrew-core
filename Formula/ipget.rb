class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "e9b99050f5fd6fc5900a890cc5d5f097fbd3950fd00aeafa013271e5317bd4b8"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "233788748853983df10588bf95efc20dddbb352411f8ed79be206722d03276ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0866c1fc5c49c93e7134866aac3ccde371329fa1b207be80be12da2ca6dfc8aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b390872e4c717f8b82d5a50ffa736f460c053e055adb88f8633fdac0d506a44"
    sha256 cellar: :any_skip_relocation, ventura:        "fe3f442e4e947fce3086ecc6fb930bf9be2dd22a1d7ee3d44ad51fbbe1041e5c"
    sha256 cellar: :any_skip_relocation, monterey:       "ae383e4e816bf7a335bad7a9a6d89cb29f4ba0b4ad5518d32e836bc9b4d04554"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad882c162aec3184a504d3de7274ca6fa0c60f7a3affa99b5f3eed834fe50940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3ca4537a2e1536933ca2cd4a17b9f8907dc0a5c3df4b04f8bdfdc74476cdb74"
  end

  depends_on "go" => :build

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
