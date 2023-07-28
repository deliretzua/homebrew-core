class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v5.1.0/drafter-v5.1.0.tar.gz"
  sha256 "b3f60d9e77ace0d40d32b892b99852d3ed92e2fd358abd7f43d813c8dc473913"
  license "MIT"
  head "https://github.com/apiaryio/drafter.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "94b8bc4a98d77f3ee2fb5ee76db46e809bfa016d3d3ed9cbc492b59ee2a62a18"
    sha256 cellar: :any,                 arm64_monterey: "be038c662204e25d6bfa3f4d51042b7e891683b10449be230af932e6f85085d0"
    sha256 cellar: :any,                 arm64_big_sur:  "e87c12f12a181902f5013f06c3ca34608c68de6216d90f3c2fa568d4f8a35a5e"
    sha256 cellar: :any,                 ventura:        "c1eea15dd9f858e36609ec04ea8d1af84651be969974bb04164a8929e1c50332"
    sha256 cellar: :any,                 monterey:       "c4758b5fced48426a6737ff6028b98324c9ac7b45f4b89fe7c3b3d79119f0840"
    sha256 cellar: :any,                 big_sur:        "74fcc290a59528b6be28739c6e4e9fac9660051430c74910f006cb000271a235"
    sha256 cellar: :any,                 catalina:       "29fa18ff148f6ebf454ed383181384bfb9aff1520e64072dfb386445bf8e52a3"
    sha256 cellar: :any,                 mojave:         "2a56e75e39f7b46eba355ae6163b645e161c4e458a4f127c37a948377143ac3e"
    sha256 cellar: :any,                 high_sierra:    "125fb907888693fd3d638a79d185483f44112f5bb64f098626aa17f00b25513d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "327e24cfd4df62c3a6941735c16b8e63f70eb78bf14184a884c0ddb3fabc1432"
  end

  depends_on "cmake" => :build

  # patch release version
  patch do
    url "https://github.com/apiaryio/drafter/commit/481d0ba83370d2cd45aa1979308cac4c2dbd3ab3.patch?full_index=1"
    sha256 "3c3579ab3c0ae71a4449f547b734023b40a872b82ea81a8ccc0961f1d47e9a25"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"api.apib").write <<~EOS
      # Homebrew API [/brew]

      ## Retrieve All Formula [GET /Formula]
      + Response 200 (application/json)
        + Attributes (array)
    EOS
    assert_equal "OK.", shell_output("#{bin}/drafter -l api.apib 2>&1").strip

    assert_match version.to_s, shell_output("#{bin}/drafter --version")
  end
end
