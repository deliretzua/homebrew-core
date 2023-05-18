class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/80/bc/46ec328dcb9abcc8e9956c02378bfd4bfb053cb94fcf40b62b75f900d147/mongo-orchestration-0.8.0.tar.gz"
  sha256 "9cb17a4f1a19d578a04c34ef51f4d5bc2a1c768f4968948792f330644c9398f6"
  license "Apache-2.0"
  head "https://github.com/10gen/mongo-orchestration.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "405127e453e31ede09efe2d9f227f1c3eb73284d83acfdfd6b7e8f933cf98ae5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d23d95a71adb37e14c4e38e026d7e764af41480dd90841d74a7a2422f7f1f0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90a4581f44b9dbdeb3acd2178844740b9c972d9ab482012fd621e0298fd2f2e6"
    sha256 cellar: :any_skip_relocation, ventura:        "2ae530fa702c4b5ab68fe65c83ce5311fc4196685fc406b824c29368c55468ce"
    sha256 cellar: :any_skip_relocation, monterey:       "9cd9b0ad3bfdda51c34bf4ae6fb0a8389b8d0eb2706f0bd08225d5ee8e0c66ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba9a03b8247ec1bdb1beb5dcc3ba9ec4d92950af2e1a15db1eefc9f2b4d802f9"
    sha256 cellar: :any_skip_relocation, catalina:       "6653fea0b774f6007ac75652a1a90c4719c3e913d8b35f3af9e0616baa7fc46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b7a67022d7990bbe34724e0ebc0b5ffb3b5f7833f4b89bfb0ffb3614750264c"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/8c/e7/8e6387d59a352c5799e917a23e7b76771a8bb97322c1ce7e42934d0066c3/cheroot-9.0.0.tar.gz"
    sha256 "3d47ad9ee19ecbec144b4758399036692fdbf67a40b96eef1fb1454367b3d338"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/91/8b/522301c50ca1f78b09c2ca116ffb0fd797eadf6a76085d376c01f9dd3429/dnspython-2.3.0.tar.gz"
    sha256 "224e32b03eb46be70e12ef6d64e0be123a64e621ab4c0822ff6d450d52a540b9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6d/82/e94ee23a7924ab1c3b617e42ddee24a60add7d988497d5cde8ae524b1525/jaraco.functools-3.6.0.tar.gz"
    sha256 "2e1a3be11abaecee5f5ab8dd589638be8304cc4cb91361fe5e683f4b6d9fb7a3"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2e/d0/bea165535891bd1dcb5152263603e902c0ec1f4c9a2e152cc4adff6b3a38/more-itertools-9.1.0.tar.gz"
    sha256 "cabaa341ad0389ea83c17a94566a53ae4c9d07349861ecb14dc6d0345cf9ac5d"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/9a/31/482f7401e7bbbeb66ab6b4ac263e2b50435f4329cce1e72378972d48f6b5/pymongo-4.3.3.tar.gz"
    sha256 "34e95ffb0a68bffbc3b437f2d1f25fc916fef3df5cdeed0992da5f42fae9b807"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e0/69/122171604bcef06825fa1c05bd9e9b1d43bc9feb8c6c0717c42c92cc6f3c/requests-2.30.0.tar.gz"
    sha256 "239d7d4458afcb28a692cdd298d87542235f4ca8d36d03a15bfc128a6559a2f4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system "#{bin}/mongo-orchestration", "-h"
  end
end
