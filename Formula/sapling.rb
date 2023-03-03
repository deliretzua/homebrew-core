class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20230228-144002-h9440b05e.tar.gz"
  sha256 "70483afad6d0b437cb755447120a34b1996ec09a7e835b40ac8cccdfe44e4b90"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0ace6f8d4217aef506650fec20728311ac6f309cb4209c30af20d76d228f331c"
    sha256 cellar: :any,                 arm64_monterey: "76f6622501b2c9d61fe31ab75ab25cace1d7f823cdf574cc1682f33c6a64b4c6"
    sha256 cellar: :any,                 arm64_big_sur:  "8d3b6684e15d0684d865e00660b2b9a181b359870239dc840e671ade15cdc09e"
    sha256 cellar: :any,                 ventura:        "18e6aff992756525db3f1189d13ee651ed1d82c537ebe526e9f1db9c33547edc"
    sha256 cellar: :any,                 monterey:       "a5ffeb61307729636bbbf1189c39300e256d44ed0db89ed5dc9cd2282c1a6b03"
    sha256 cellar: :any,                 big_sur:        "9d47357638d7a2277bbaf6bcebc246e8017ccfd720766c423778ccf8c99addb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "137b8880f450ef73650bfdbb7644f8555ba724f58506832a1697ff891948286a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  def install
    python3 = "python3.11"

    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["SAPLING_VERSION"] = version.to_s

    # Don't allow the build to break our shim configuration.
    inreplace "eden/scm/distutils_rust/__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "eden/scm", "install-oss", "PREFIX=#{prefix}", "PYTHON=#{python3}", "PYTHON3=#{python3}"
  end

  test do
    assert_equal("Sapling #{version}", shell_output("#{bin}/sl --version").chomp)
    system "#{bin}/sl", "config", "--user", "ui.username", "Sapling <sapling@sapling-scm.com>"
    system "#{bin}/sl", "init", "--git", "foobarbaz"
    cd "foobarbaz" do
      touch "a"
      system "#{bin}/sl", "add"
      system "#{bin}/sl", "commit", "-m", "first"
      assert_equal("first", shell_output("#{bin}/sl log -l 1 -T {desc}").chomp)
    end
  end
end
