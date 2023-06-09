class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning.git",
      tag:      "v23.05.1",
      revision: "484d4476256815056e5d82991d677553c74315c1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12c81515a1c83bc55eb01efc238b404ed21f717522b72f00a375557b695d6c0b"
    sha256 cellar: :any,                 arm64_monterey: "265dceb9966ad0c47f5dabf3c3aacef1535ebf162dc05868f459c434eb9c10e8"
    sha256 cellar: :any,                 arm64_big_sur:  "dcf5b57648fdc66f518d3b8d0ffefe6e52dd88b0b499fdabf1a6f040f2c619a2"
    sha256 cellar: :any,                 ventura:        "89de9aa4c8f7ba6649b490d2add34a438787480b25979ee521ffb3c8aca3691d"
    sha256 cellar: :any,                 monterey:       "fa0a9962a8f234deb84dc852615df949efe05d19acb3c2e74ddb15963415c0f8"
    sha256 cellar: :any,                 big_sur:        "dcae189430f1ee7724e82ec4f239e4d0b7fe8a5881a139c1f453a7c5874e0f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "371e275ea511089844ce96851a3126a17e6ded742d9b86c04752bed9c56f9ea6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "libsodium" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "poetry" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.8" => :build
  depends_on "bitcoin"
  depends_on "gmp"
  uses_from_macos "sqlite"

  def install
    File.open("external/lowdown/configure.local", "a") do |configure_local|
      configure_local.puts "HAVE_SANDBOX_INIT=0"
    end
    system "poetry", "env", "use", "3.8"
    system "poetry", "install"
    system "./configure", "--prefix=#{prefix}"
    system "poetry", "run", "make", "install"
  end

  test do
    lightningd_output = shell_output("#{bin}/lightningd --daemon --network regtest --log-file lightningd.log 2>&1", 1)
    assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end
