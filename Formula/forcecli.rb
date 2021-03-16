class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.30.0.tar.gz"
  sha256 "4c72fc1edc8b0784bafc37ec30e107c1eb2a62c71b8ee4393235bde4a5c96b9c"
  license "MIT"
  head "https://github.com/ForceCLI/force.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d67c0177daaa47d31fb17fe1a48dde54ccf14168d7bf821cfc6cc3a1578808ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "64d643a4421cdb63de14ee703f020cb5b03c0f7e7aad09915f719c3b26d9b6a9"
    sha256 cellar: :any_skip_relocation, catalina:      "12c3c9887210c8dc606980b268e5bde2b3ae9ec15dc45e4ee7eac35e38c48ab1"
    sha256 cellar: :any_skip_relocation, mojave:        "32ed79f122d17880baa3ead235ce8c3624a5663f45213020726bc3f6949c4988"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
