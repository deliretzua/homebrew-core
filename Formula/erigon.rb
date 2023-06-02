class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.44.0.tar.gz"
  sha256 "dd9da0fc581d37d0fe386693cc611a37cf7b890bf8bc7549cc0c88674322f72a"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bb9f08d0eac3ef7f5bac0e532ab3a0534e74af779f20c5ff6937c79e183c10b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ec4db5e70959cd1f3080b4b814637940a11c559b2dddcf1686d190ecff0d55b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21fafa227a6ba4438160f244954b6101ea7cadf465c0668bb52067437cd286e8"
    sha256 cellar: :any_skip_relocation, ventura:        "2194203cc27c2b9b5674c324e97587378cd3482c66bc75c6833511377e12ef1a"
    sha256 cellar: :any_skip_relocation, monterey:       "7572a087049a42136405076145de7167bdd78f404c79e12378ad6411f1b11d13"
    sha256 cellar: :any_skip_relocation, big_sur:        "dac5c9aaf0287584b8e5e690b66a11e8eef4e420c83b89494071268e90c8c81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f5f6686c4f36887676bc6885c59da1e5794b0c5bf083d0c8ef498cd55fbe614"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "make" => :build

  conflicts_with "ethereum", because: "both install `evm` binaries"

  def install
    unless build.head?
      ENV["GIT_COMMIT"] = "unknown"
      ENV["GIT_BRANCH"] = "release"
      ENV["GIT_TAG"] = "v#{version}"
    end

    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    EOS
    args = %W[
      --datadir testchain
      --log.dir.verbosity debug
      --log.dir.path #{testpath}
    ]
    system "#{bin}/erigon", *args, "init", "genesis.json"
    assert_predicate testpath/"erigon.log", :exist?
  end
end
