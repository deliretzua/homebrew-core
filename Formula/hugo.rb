class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.112.1.tar.gz"
  sha256 "fdc410e4c274102d0ba78fffd158c0ee485fba121c5efd54fe2c5db8fe6ee2dc"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "826bd28cf1e7231156f68e4e02f5da82b75e078c648ae341fdf1f55d1ae0acc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8639fd26b525b359263052956e9ffa65260d24c4379cdd932fd6d69a1d5c9a3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dff933290db6b5d29a748d7aad4eaf923fdbe77e8448f2a262cb0c3b6d59927"
    sha256 cellar: :any_skip_relocation, ventura:        "cd6c893f3d0dbb563178ab176ab2c1636320720c76a2b1214fb4a146e01346df"
    sha256 cellar: :any_skip_relocation, monterey:       "2b1f6a971d4d79b068ba52514781d8c29876567428035d82916978b89025d445"
    sha256 cellar: :any_skip_relocation, big_sur:        "c431896c3487783a867301b1e3272dd69568d920e34cb811967e70a2d9e54fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b9f421b6e28b7692e46488ca84b55321e804c845c80ecf30cd3ee4b616a487"
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
