class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://cab.spbu.ru/files/release3.15.1/SPAdes-3.15.1.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.15.1/SPAdes-3.15.1.tar.gz"
  sha256 "db0673745459ef3ca15b060bf9cff9aa1283823f8b3ed9e07b750d1d627d6249"
  license "GPL-2.0-only"

  livecheck do
    url "https://cab.spbu.ru/files/?C=M&O=D"
    regex(%r{href=.*?release(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "85776ce52d23b7bf4fb0e9ecdd8bce77c722706a662b677ad74b13b62e43c8a3"
    sha256 cellar: :any_skip_relocation, catalina: "4e80e0f7e271b2653d6fc9d425d3623096f349ab582f1f03e223c7ce815a4b5c"
    sha256 cellar: :any_skip_relocation, mojave:   "e182a129f1519391ba6267c36eb1f6bb08df89edb33b0c4edb3c7473dad17791"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "jemalloc"
    depends_on "readline"
  end

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    bin.find { |f| rewrite_shebang detected_python_shebang, f }
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
