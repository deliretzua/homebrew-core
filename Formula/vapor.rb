class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.7.0.tar.gz"
  sha256 "1ef57173057c922eb71baaaa5329ab78fd59449f3bca2b129d2d28588f4a3d9a"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9a78a731706394ad89d0527bfb82da1d488d8aea189fa718137624b8431f260"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d550b6f7e33db1ccc90b1040049b99a3de925db0432869f7147972f22b2b5c"
    sha256 cellar: :any_skip_relocation, ventura:        "9d58e562a14d687489b63f16730232cbf8a2544c1b09e7d0a81c100882a70319"
    sha256 cellar: :any_skip_relocation, monterey:       "635ce0c09f59651038a352f136b1afd7eb6a20c6689e354f17d183f257709e8a"
    sha256                               x86_64_linux:   "2428915539bb1f55aa7af350733a65fee8fdb76a2f471e4c8ad903bec8190d56"
  end

  # vapor requires Swift 5.6.0
  depends_on xcode: "13.3"

  uses_from_macos "swift", since: :big_sur

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/vapor", "vapor"
    bin.install "vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_predicate testpath/"hello-world/Package.swift", :exist?
  end
end
