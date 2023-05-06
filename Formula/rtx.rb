class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.29.4.tar.gz"
  sha256 "013980ff1685f38d123f9cc902ca401030e951619649be0e9ffa0e859248659b"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7c60b44af1651d439ed873ff366fced06287372b4648a213db4a578caf63c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "671a8a9bd62770af592a1833ff136782dfbc7a16a71598d9214d1e2e5344fb02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e2ec94d487359bbc00a9f057793f26d29cafbab2eb345a39dfc861fa106b839"
    sha256 cellar: :any_skip_relocation, ventura:        "fc23f0269c7b34ac11104ecff78f7d0bbbac7e310f604723d2f127e6708c21f4"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e70f52a721a684013415017e8e8f91dad2ddca5d79aa8f99776409806c86ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f6fa9a616af13dd8e34445bec748a5e99075e181e22eaf6ccec9a76c79e174a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72b2b2cb9a4c83b46bf582c69b5addcd3f81f50d4985d68b91304dc89a1518b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
