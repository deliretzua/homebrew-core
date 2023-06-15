class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.25.tar.gz"
  sha256 "7592aaddc49146b15a9822e97d90d917a1bd8ca33a4fb71cd98ef8c8c06eb3cf"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3889ec9044a69b18fa9d61fa371cbff4438ec7c095db01ba476b73261e5f7fb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3889ec9044a69b18fa9d61fa371cbff4438ec7c095db01ba476b73261e5f7fb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3889ec9044a69b18fa9d61fa371cbff4438ec7c095db01ba476b73261e5f7fb9"
    sha256 cellar: :any_skip_relocation, ventura:        "0ce064aabda0438f12fd4b8dbc54b287286f70a09abed2d5067aad3a06feda58"
    sha256 cellar: :any_skip_relocation, monterey:       "0ce064aabda0438f12fd4b8dbc54b287286f70a09abed2d5067aad3a06feda58"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ce064aabda0438f12fd4b8dbc54b287286f70a09abed2d5067aad3a06feda58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9d2dbe78ce86aa3896945ed42f5db165fbcb4a29a13bf72db4e1b9fd300c9da"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/rhysd/actionlint.version=#{version}"), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~EOS
      name: Test
      on: push
      jobs:
        test:
          steps:
            - run: actions/checkout@v2
    EOS

    assert_match "\"runs-on\" section is missing in job", shell_output(bin/"actionlint #{testpath}/action.yaml", 1)
  end
end
