class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.13.1.tar.gz"
  sha256 "5bdf36ffe6a8cd7979fdd54dc48c76ad96fc65af11929e17b3b686992d32e541"
  license "MIT"
  head "https://github.com/orf/gping.git", branch: "master"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^gping[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1603ee93bf874d8d35556d8059fec45bb53c5459fc4faad5baa7780e4c0d60ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "decb68ec6a5fc910c7d16e06577476092fe5085c7ea0832c7a17b9ce091c297a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2fdaacbe7121ee078a0887081c502c34c38c3257a8f80141b2d20fea696054a"
    sha256 cellar: :any_skip_relocation, ventura:        "d562927db7d5b4a8d4cb79cc69f4f4d6b569572d6b2b741b8f013c327f648e42"
    sha256 cellar: :any_skip_relocation, monterey:       "be2fc48bce45ebd9a67ccb48ab4b022ee8443204015ad20b23a576d144642eca"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5228d3620d0f0bf6b8386cd39bf75175446f5011ca35678a0f15dec4f4e2791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c368eb8ea5223b426df4a4eceead715cc828d8a358ed06c8ff68b8d8da3bac37"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "iputils"
  end

  def install
    cd "gping" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    begin
      screenlog = r.read
      # remove ANSI colors
      screenlog.encode!("UTF-8", "binary",
        invalid: :replace,
        undef:   :replace,
        replace: "")
      screenlog.gsub!(/\e\[([;\d]+)?m/, "")

      assert_match "google.com (", screenlog
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
