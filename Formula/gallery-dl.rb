class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/9f/f1/b5d620a5f634f0fe96e1485e503304e68d848d292ee04f28c3ebba4b8c07/gallery_dl-1.23.5.tar.gz"
  sha256 "3619ee5bbaeae4382b9e4c3f9d43bfa4583f4a1d83fddf6014221bfa0432e501"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd9dc6189b19dedf221b9619578e6b86f9bc49fabd3159bf275910a89dbf5e05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4ca8bf32de32bf8463971a5b5969b508d89a7b64b8f6fdb58734bf5f631729e"
    sha256 cellar: :any_skip_relocation, monterey:       "053d59fa57344930b15ca94153d01f86458e54e04397e5f78b20cafc0c0ff784"
    sha256 cellar: :any_skip_relocation, big_sur:        "f182d3a99890729c6389b30e3e046706c115aa7bf7c6a7cb189bda5023cc16f6"
    sha256 cellar: :any_skip_relocation, catalina:       "ccffb0d6c73b94a02de40971fb4e25d6e293e6fc453f1c7ad789d2bf4f79ca84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8bf49fb31652ef504f2b53dfd70df241cebd4b55707edd30bab47c44d995767"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
