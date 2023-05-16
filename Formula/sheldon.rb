class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.7.2.tar.gz"
  sha256 "8ce4b93376f4365e436d04b2ac5aaf18d1b90285f7d833901e7a78c32f6200db"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36e78d9197e6664785a1f34a693d9dd2057b45381d7609f2b3c5acd412bcf925"
    sha256 cellar: :any,                 arm64_monterey: "1c113f576dc3db9a92c46d26d7adc8be093be5cba376e12acbbbeecbf254475e"
    sha256 cellar: :any,                 arm64_big_sur:  "179bf43b9c8d72b289e10735c6e1d0ce78915a6fea2fa6e340c02f5e63beedd7"
    sha256 cellar: :any,                 ventura:        "5261fe8dfadee55061f0696f5c41a466071cff81630da3620952eed25d786742"
    sha256 cellar: :any,                 monterey:       "e44425b595a71aea3cfdb1cd495ac3e3be98177928a81c97872ae136209dc059"
    sha256 cellar: :any,                 big_sur:        "9408cf7ef6b68fb80bd240af43ddc94753715036677becf76c7d8a1e501cd58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f0528fb470638d4fccc6235ac982148ccd254c473a25f8828ab7fcd41da333"
  end

  depends_on "rust" => :build
  depends_on "curl"
  depends_on "libgit2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    # Ensure the declared `openssl@1.1` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Replace vendored `libgit2` with our formula
    inreplace "Cargo.toml", /features = \["vendored-libgit2"\]/, "features = []"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/sheldon.bash" => "sheldon"
    zsh_completion.install "completions/sheldon.zsh" => "_sheldon"
  end

  test do
    touch testpath/"plugins.toml"
    system "#{bin}/sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?
  end
end
