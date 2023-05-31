class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "d7ec18a684ac6e3f45324abb36610fd60469e268c4b29a391abb38c8f920784e"
  license "MIT"
  head "https://github.com/wp-cli/wp-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69e4f608a405f861788445d6c22e9975f2fbdf0b5659001d5ca96ea112036e91"
  end

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}/wp && complete -p wp'")
  end
end
