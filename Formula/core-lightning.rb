class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning.git",
      tag:      "v23.05",
      revision: "d1cf88c62e8ff10485f3b40cddb93fc0063ba92a"
  license "MIT"

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
