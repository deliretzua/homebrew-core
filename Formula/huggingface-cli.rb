class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/ec/c7/75abde5e0a8357da0ab6e8bbe8ed02a217a5f8da2d11accc9d91f41ef68d/huggingface_hub-0.14.0.tar.gz"
  sha256 "42eeab833284e3fc1d39263cf9c3d1bb36b129acdd8195838694d165e8dd6cae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f626b7d164f2f199651085375ad868e0cbe5afc4b3cb8123e8875d349ab632aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f1be476dd5bf3c001c8f533b2c62084c54ea05cce815ca9a08ae21af5a463f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa0bb6d32b7b2b593f4a6eb2c609c74d48adb5a4d615ce8105599f52d3f39464"
    sha256 cellar: :any_skip_relocation, ventura:        "d6ce807b78fd22647b66137bfd99b5d8f1392955bbecd743b0f9b59fb9b577d1"
    sha256 cellar: :any_skip_relocation, monterey:       "0bbc8df2af9886001b8891998bbb94bde269d9154c66cd0a527a5698e76ab113"
    sha256 cellar: :any_skip_relocation, big_sur:        "4937bcac914101b94f00c1c703ef84b50a213b956f80becee6a161ce4de766ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c073ee5b1e5d33b0a3424a533bc3d41308784de0548d751d44a8f010e94aeba6"
  end

  depends_on "git-lfs"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/24/85/cf4df939cc0a037ebfe18353005e775916faec24dcdbc7a2f6539ad9d943/filelock-3.12.0.tar.gz"
    sha256 "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/d8/c3/7eb5ace7aac24890fd6f3dbf49d547305237bd4002903f19b524061ce8ae/fsspec-2023.4.0.tar.gz"
    sha256 "bf064186cd8808f0b2f6517273339ba0a0c8fb1b7048991c28bc67f58b8b67cd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    whoami_output = shell_output("#{bin}/huggingface-cli whoami")
    assert_match "Not logged in", whoami_output
    test_cache = testpath/"cache"
    test_cache.mkdir
    ENV["HUGGINGFACE_HUB_CACHE"] = test_cache.to_s
    ENV["NO_COLOR"] = "1"
    scan_output = shell_output("#{bin}/huggingface-cli scan-cache")
    assert_match "Done in 0.0s. Scanned 0 repo(s) for a total of 0.0.", scan_output
  end
end
