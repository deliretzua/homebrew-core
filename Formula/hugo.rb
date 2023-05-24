class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.112.3.tar.gz"
  sha256 "24720523cd4feb4a746fb1462c4ad0b1ecdd4c3fbe08469d4498ca0647b9e28f"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57d92a25a7d9edde24df550331005586942cbb34a977afdf1fcf89dddb1eedc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b06626eb843e50f27b3973cf3440c4f5ef97eb638ae47854172c9e04c943f93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12c3bd505aad4f12fdc91a49197ef5c48ed69439e044e68cf080ca0f43dfa608"
    sha256 cellar: :any_skip_relocation, ventura:        "1dc4334d4c1c5ab0ee7532e5d95de68afb15fa2284cb6807e74b8e97112818ff"
    sha256 cellar: :any_skip_relocation, monterey:       "ba1cef16f10db7a589eb2d7a83faaf9bbd66f92a737861d07a714cc207374e7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e110c8d13c92b4613e310c10895616e5582a9d8a4a98522846a97c892c156ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948caabc4633211618d63a0f87f2e7c76e7e2d6eea0e3d943a9167ba23256e1a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
