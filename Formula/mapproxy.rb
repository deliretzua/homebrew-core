class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/65/0e/f3ecc15f1f9dbd95ecdf1cd3246712ae13920d9665c3dbed089cd5d12d3b/MapProxy-1.16.0.tar.gz"
  sha256 "a11157be4729d1ab40680af2ce543fffcfebd991a5fa676e3a307a93fbc56d6b"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_ventura:  "f9e6be821df823ed62ddb8c022e62760d9ef6933fbf9c54740a7165115120eb4"
    sha256 cellar: :any,                 arm64_monterey: "f756f95ac4a65fcbba1179adcccf2928d74be7c80d2af251efa9155c8d2c4c74"
    sha256 cellar: :any,                 arm64_big_sur:  "023bc9bc6c397305e5c314e84e13258dc1de81c98c00b9f0136dd6e891a920b8"
    sha256 cellar: :any,                 ventura:        "c72b39b57fdee50f70a6724ed7beaf2c6cecdaab54b77d02d3117808b091b400"
    sha256 cellar: :any,                 monterey:       "7d43175248c2a3a3c3f744a843b4f0142c6f744aa40a5bbbd5c309e0cdee2753"
    sha256 cellar: :any,                 big_sur:        "88307378320958deeaaf06888cc3ab9d529c794539df3e77a259733c0c696cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2802c2cbede2f32c152de789c1904f8c29cf55eea2ae095cc7292390f21b7ca3"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/9c/f5/cd9371194d3c939dffddff9e118a018bb7c2f560549bea4c6bc21b24eadd/pyproj-3.5.0.tar.gz"
    sha256 "9859d1591c1863414d875ae0759e72c2cffc01ab989dc64137fbac572cc81bf6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
