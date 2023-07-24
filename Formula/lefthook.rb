class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "92ca652b862b75d1fee07764bdd4244a9c79c454876ba949f679fa765187a0da"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bba8da9e3e7b8629ddb80a4d26b3cd7f647a2821d961b904b73aba1db2883851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bba8da9e3e7b8629ddb80a4d26b3cd7f647a2821d961b904b73aba1db2883851"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bba8da9e3e7b8629ddb80a4d26b3cd7f647a2821d961b904b73aba1db2883851"
    sha256 cellar: :any_skip_relocation, ventura:        "d96e0df6c50ddcc05a36695beef18dacc30b19da9d40033b5880351e51c0fcf4"
    sha256 cellar: :any_skip_relocation, monterey:       "d96e0df6c50ddcc05a36695beef18dacc30b19da9d40033b5880351e51c0fcf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d96e0df6c50ddcc05a36695beef18dacc30b19da9d40033b5880351e51c0fcf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "779a5e7d13b690eba4ba608f8febc5f4e1a8bfb98db600c553495ecce9280294"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
