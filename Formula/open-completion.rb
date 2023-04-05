class OpenCompletion < Formula
  desc "Bash completion for open"
  homepage "https://github.com/moshen/open-bash-completion"
  url "https://github.com/moshen/open-bash-completion/archive/v1.0.5.tar.gz"
  sha256 "bee63ee57278de3305b26a581ae23323285a3e2af80ee75d7cfca3f92dfe3721"
  license "MIT"
  head "https://github.com/moshen/open-bash-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ea91a3335f030fb57487c30aa307dee22587db31ff801bb7bc6a121775ba579"
  end

  depends_on :macos

  def install
    bash_completion.install "open"
  end

  test do
    assert_match "-F _open",
      shell_output("bash -c 'source #{bash_completion}/open && complete -p open'")
  end
end
