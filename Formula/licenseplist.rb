class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.24.8.tar.gz"
  sha256 "46dbc5dfe93ea924ab0ef33992e86a85b50a001e553daf57f854321f43ac0b1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7eca81ca8ff2e7e7b34b5b67d59ddf9fdae10ce650c7890d6d98315b8b95980"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ef40cdc85ccda4db6ebfceb0237fe1aca2a584385f5b2f6076a9dbb109dfcf5"
    sha256 cellar: :any_skip_relocation, ventura:        "678db5b3f4fd1cf6835e129c5bfa2c7ded100bb4ed4d2d8d6dd60256c0f1dafd"
    sha256 cellar: :any_skip_relocation, monterey:       "9662f217a4ec44f1c1859c2857b1b964fa671ae3b825c00ac3baa77371113e3f"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("#{bin}/license-plist --suppress-opening-directory")
  end
end
