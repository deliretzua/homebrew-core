class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.571.tar.gz"
  sha256 "3ab30e6d5e2f31024b99b48612b1833cfe8952e82902d8c1f3c1fc3e07c1ab70"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0b3d1b86a9f9ed6bfa734831ccf6d910e7a033109a22fe43d42479b74bd6a93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "633f5659cec9d08c9a139c31cab04961aa5335d12d16f3054595ce665c81905b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a48851446b61a503220a550819638591486ed817e9b13172505a1577fac755cb"
    sha256 cellar: :any_skip_relocation, ventura:        "0a01a3fae49cc7bc89ca8fdec1345e1f9be3e5fbe9d56aab073d05dfdba496f7"
    sha256 cellar: :any_skip_relocation, monterey:       "41255a8a2976fa2279411236e2b9d0eb40f043646bb1dc72e6a1d1eeec2975c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bdd0c4741388b88fbdb5a88e851a33de203a310d998ae2e1de49f1a87781951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c82ec975d5095052c988cefc5231fa8d3eb8b031a30f9bce66504f3cb92deaf0"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
