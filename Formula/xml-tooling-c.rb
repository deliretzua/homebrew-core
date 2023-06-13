class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.1/xmltooling-3.2.4.tar.bz2"
  sha256 "92db9b52f28f854ba2b3c3b5721dc18c8bd885c1e0d9397f0beb3415e88e3845"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?xmltooling[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "70546cd1bdd2b145453140464347a4c415640bf0910d8e475fe3af6cd60c5348"
    sha256 cellar: :any,                 arm64_monterey: "132f336a4e753c773c04954d345ec2b120da10fd9af2f208d3d4649d51c4b69e"
    sha256 cellar: :any,                 arm64_big_sur:  "c20e6377af4c3c08178d7b974567cf7edef82114d46f4f172eb60c8a4956d330"
    sha256 cellar: :any,                 ventura:        "769896be9a616c020f41436711754b804946ff503ca6fcb4bb71607c4b88ec1d"
    sha256 cellar: :any,                 monterey:       "ffef814bccf24853bc8779e175e2bffe4a4e548d189b3b5d70b531ae3c92579c"
    sha256 cellar: :any,                 big_sur:        "586a2f170d7e6ebbb2f0fb77506b3de284495e29218165bad243225e2a6d6311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b42c90c1f870961f42abc3c9d91dafe9ac66012ef11736aa4c61b72e7e87d57"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  uses_from_macos "curl"

  def install
    ENV.cxx11

    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl@3"].opt_lib}/pkgconfig"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
