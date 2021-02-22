class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.57.0.tar.gz"
  sha256 "a5a3eda3075f141f419d7bf1bd4e8e0decf729b5a7ff82b5b01a6331c4f2afa9"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c34bd864b760afa7efe8c04cfd3103a31206c42f5013e2d0ffb47b5e5d2dcb17"
    sha256 cellar: :any_skip_relocation, big_sur:       "b77a46d58c00e48d0cb74d1489db0576ebba7088708fd7214203de896c68830c"
    sha256 cellar: :any_skip_relocation, catalina:      "12a7abe74ce13a1c2e58b8e921eadaa748e96a1bc6516701873295c2b5583de9"
    sha256 cellar: :any_skip_relocation, mojave:        "979f037ea6eb5c6ab13519994eafb622b0fcd0e5d1e469bf0fc7c071062e6a58"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ].join(" ")

    system "go", "build", "-ldflags", ldflags, *std_go_args, "github.com/digitalocean/doctl/cmd/doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
