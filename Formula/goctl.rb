class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.5.3.tar.gz"
  sha256 "50611a3acf261642d7b422428b5c72b935c408d13a9be82030a3703a0d730567"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e6785834ac60846dbfd016597e649e5b229c0aecced702e5e390fb7fea45411"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e6785834ac60846dbfd016597e649e5b229c0aecced702e5e390fb7fea45411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e6785834ac60846dbfd016597e649e5b229c0aecced702e5e390fb7fea45411"
    sha256 cellar: :any_skip_relocation, ventura:        "973276ca58e543a4f8410945bac69aafcaed0f96ca5a2a709d50b9cfb163bedb"
    sha256 cellar: :any_skip_relocation, monterey:       "973276ca58e543a4f8410945bac69aafcaed0f96ca5a2a709d50b9cfb163bedb"
    sha256 cellar: :any_skip_relocation, big_sur:        "973276ca58e543a4f8410945bac69aafcaed0f96ca5a2a709d50b9cfb163bedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b90d41a857e7ac0e41a20bd2e98302a0b5644b16ecad6df9a45ff0c5444d828"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath/"api/main.tpl", :exist?, "goctl install fail"
  end
end
