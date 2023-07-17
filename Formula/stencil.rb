class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "a89556d78ea38d2284520b43b3de7e999f11722fccde7996fd02d2f65bb23ce8"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a92478ad0dc897b606bbea6a95675c0919ae53ae697c61583985061f253a8616"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a92478ad0dc897b606bbea6a95675c0919ae53ae697c61583985061f253a8616"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a92478ad0dc897b606bbea6a95675c0919ae53ae697c61583985061f253a8616"
    sha256 cellar: :any_skip_relocation, ventura:        "98e8fcd7e19eda7fdeece2a4e8b751659a9061d1aca608f009f4e5ef6b899888"
    sha256 cellar: :any_skip_relocation, monterey:       "98e8fcd7e19eda7fdeece2a4e8b751659a9061d1aca608f009f4e5ef6b899888"
    sha256 cellar: :any_skip_relocation, big_sur:        "98e8fcd7e19eda7fdeece2a4e8b751659a9061d1aca608f009f4e5ef6b899888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e3377615d9bd04ffa03d7b795f931ab403ac990747d33dc966306999b951e0b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/getoutreach/gobox/pkg/app.Version=v#{version} -X github.com/getoutreach/gobox/pkg/updater/Disabled=true"),
      "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end
