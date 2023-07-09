class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.8.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.8.tar.gz"
  sha256 "0a501663a59c3d24a03683d2a1fba4c05b4f07a2917152c58a685d82adc0a720"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c4904f8d230ac972b49388687ff2113055435f64d82d7cfa53594c907e9a55fb"
    sha256 cellar: :any, arm64_monterey: "12e499fbe35d8d0af00dd4b481f3551571e0df4ebe061a730a1c91e3fc17e680"
    sha256               arm64_big_sur:  "70e47d792b5442204e46a4d6afd2a99fbf185494e0924d969bdd209a30179cdc"
    sha256               ventura:        "4eb03fed85048f55ba0f3726ccc0b2abc7d7f2c9a69b7199ced771f70d85a04e"
    sha256               monterey:       "802b854c2c2a063610fd10d00e15548030794766f704865a7c81eec513dca4ad"
    sha256 cellar: :any, big_sur:        "991861b4c252151ebee48befa21f53ab2c50eff47832f0b5dd4b29b74d9d5c01"
    sha256               x86_64_linux:   "246895b0bcf47660f9dd3c663dd39bfe893bc98fa7a20787df1737d86652a1a2"
  end

  head do
    url "https://gitlab.com/oath-toolkit/oath-toolkit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"  => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end
