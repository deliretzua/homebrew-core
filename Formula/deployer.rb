class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.1.3/deployer.phar"
  sha256 "70a80ee89d4cb0f7ddc6280723811bbb09ac838765a72da05a530b009fe8c034"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d7dcfa324aea05cb355d26d690b7afc1fd02317469da2e33e324c0c77a19b45a"
  end

  depends_on "php"

  conflicts_with "dep", because: "both install `dep` binaries"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system "#{bin}/dep", "init", "--no-interaction"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
