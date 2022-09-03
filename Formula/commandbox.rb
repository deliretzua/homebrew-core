class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.6.0/commandbox-bin-5.6.0.zip"
  sha256 "d2fc81030feab7b074b5f2e2791dccb9a560a2025df0db5044ce8ab54470c683"
  license "LGPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71f8e7eddbf792911e3401152c588cdede8812ad0f19574154852126650b85f0"
  end

  # not yet compatible with Java 17 on ARM
  depends_on "openjdk@11"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.6.0/commandbox-apidocs-5.6.0.zip"
    sha256 "685093aa530706bc0c25e2d6daed9a7425e63707842654d7094128405511ee92"
  end

  def install
    (libexec/"bin").install "box"
    (bin/"box").write_env_script libexec/"bin/box", Language::Java.java_home_env("11")
    doc.install resource("apidocs")
  end

  test do
    system "#{bin}/box", "--commandbox_home=~/", "version"
    system "#{bin}/box", "--commandbox_home=~/", "help"
  end
end
