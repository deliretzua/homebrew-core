class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.10.4.tar.gz"
  sha256 "d3dd58884b0724db25f5d95ce8d0130689866a82ab20ee602e5ce852465a05a8"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "216995b82984d66c7b65962a968218eb67d6617f2bf49761a9e31552e34e70ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20ca25a283933048ce91ba9d3c9893f42ee85711f35a5678f5052b166cb7c1f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11f2eb31f661c1ebae5c33fa01974b03dbf242a07c8a176ac0ccaaafcaa340da"
    sha256 cellar: :any_skip_relocation, ventura:        "d123eace24b01fe4fecb399771f4036c72137a35fb680521cde543ce331e4fb6"
    sha256 cellar: :any_skip_relocation, monterey:       "34ea9ea219af51ef0029f562ba3b5fa3c4b3ad07d72a271c815527564f9574b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "85da07fb510e05140afb3e701b47b8ca87172d9067ef9035e05a7cbe67964ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "827029b5ba94040dd0ebc0e5c08d142f3fc69ed0628b4f59c633152a5e239845"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  uses_from_macos "python" => :build, since: :catalina

  on_macos do
    depends_on "cargo-bundle" => :build
  end

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

    return unless OS.mac?

    # https://github.com/burtonageo/cargo-bundle/issues/118
    with_env(TERM: "xterm") { system "cargo", "bundle", "--release" }
    prefix.install "target/release/bundle/osx/Neovide.app"
    bin.install_symlink prefix/"Neovide.app/Contents/MacOS/neovide"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/neovide --version")

    test_server = "localhost:#{free_port}"
    nvim_pid = spawn "nvim", "--headless", "--listen", test_server
    sleep 10
    neovide_pid = spawn bin/"neovide", "--nofork", "--remote-tcp=#{test_server}"
    sleep 10
    system "nvim", "--server", test_server, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end
