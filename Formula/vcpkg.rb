class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2023-06-08.tar.gz"
  version "2023.06.08"
  sha256 "b13cd88b019a64a7c169dcca753e44e677b351d461df5b133fc92b1aa982f63a"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(/v?(\d{4}(?:[._-]\d{2}){2})/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5da4fea18bbff56b7c43152cbac5a1ec9e73e86e6768f9395ecb333552814a0"
    sha256 cellar: :any,                 arm64_monterey: "cf289178571c9b8dadb8177e59de4e16de5e96acddbcf21b298d7497186ba6cd"
    sha256 cellar: :any,                 arm64_big_sur:  "95e01f2255756ac7516a79ed85b2387efb8d68d1943bee7300fea7a4a244acc5"
    sha256 cellar: :any,                 ventura:        "97074e07204363257217a4453ecafc59a9d348fa2623b4fb81593b7180fe33b0"
    sha256 cellar: :any,                 monterey:       "fae1c55fd129150320de7eff5f71e4794e4b5557d52505b2bfeba17815b94b7c"
    sha256 cellar: :any,                 big_sur:        "b1f30666f55ac7260a3c5764dd005df1caed67a2465b912955599e3ef6e78e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37832f423089537b3a758048e721d4c75f264502a548617b70c882b7ae99e852"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "locales/messages.json" do |s|
      s.gsub! "If you are trying to use a copy of vcpkg that you've built, y", "Y"
      s.gsub! " to point to a cloned copy of https://github.com/Microsoft/vcpkg", ""
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    message = "error: Could not detect vcpkg-root."
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end
