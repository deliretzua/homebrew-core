class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.14.tar.gz"
  sha256 "6202749b92b3de8220639157794fe820bea9fb6d81ad63e7649a3d08b134c0d8"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b468b0925db42368fd268c0a21216ef36edf527ad86d6d6b39a2639b544985b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "897e121110439f075ea2fc2e0cca767cba9f6b8e8df142d06e335e95be571452"
    sha256 cellar: :any_skip_relocation, catalina:      "897e121110439f075ea2fc2e0cca767cba9f6b8e8df142d06e335e95be571452"
    sha256 cellar: :any_skip_relocation, mojave:        "897e121110439f075ea2fc2e0cca767cba9f6b8e8df142d06e335e95be571452"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "build/tendermint"
  end

  test do
    mkdir(testpath/"staging")
    shell_output("#{bin}/tendermint init --home #{testpath}/staging")
    assert_predicate testpath/"staging/config/genesis.json", :exist?
    assert_predicate testpath/"staging/config/config.toml", :exist?
    assert_predicate testpath/"staging/data", :exist?
  end
end
