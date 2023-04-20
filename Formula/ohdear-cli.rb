class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v3.5.1/ohdear-cli.phar"
  sha256 "d981492cc12eb3aa185c937223632da4390f35738eb1ad0cf432895ed08c1a71"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2bd809e756e658453caa7c5ac7e8e11011ae807538b7df05726fe68c824f165"
  end

  depends_on "php"

  def install
    bin.install "ohdear-cli.phar" => "ohdear-cli"
  end

  test do
    assert_match "Unauthorised", shell_output("#{bin}/ohdear-cli me", 1)
  end
end
