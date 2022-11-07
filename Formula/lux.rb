class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.16.0.tar.gz"
  sha256 "e16f3ec485793326c09f6b7096edacbb117fcbbd40341289e055ea19a5347033"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20c7ec1fcbca431d24f89933083303a850e1df0c4f209c654edb1260550b3109"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c88913410858105cb233f3076167d8cfcc7cc21374a9cc1134e1a520c6ec6618"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d31fd3e601f2b122ad705fdbc8044b6a55f5b94a512949aca0359cd869d39c56"
    sha256 cellar: :any_skip_relocation, monterey:       "a2039236ff2da7493d2a539dae8af265f0f09dc565f5b6a569e8be6378eda475"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f883e14b543c0df497f7ab66c4e76bd335b78b03d41e2063e97707075a7aa75"
    sha256 cellar: :any_skip_relocation, catalina:       "2cb75509d7e2047811af1dd550a0c7febeedae1b935a3a6da16a9732f2e2b319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1324047684ba3a1479977df3b979df584299e63c8aa4924f1c8f6d8fda07b08a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://github.githubassets.com/images/modules/site/icons/footer/github-logo.svg"
  end
end
