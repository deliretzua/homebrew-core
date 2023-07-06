class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.97.0.tar.gz"
  sha256 "98ca6b4ae7ce77ef1eff2701a158c840e783deb02bfe0870de1c4a24e14ff2a9"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a08adc57b6481f9ef64489488dbca211ae05ffa542eea9068205f32571d507cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a08adc57b6481f9ef64489488dbca211ae05ffa542eea9068205f32571d507cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a08adc57b6481f9ef64489488dbca211ae05ffa542eea9068205f32571d507cd"
    sha256 cellar: :any_skip_relocation, ventura:        "01a4193e0c01cd6a02f5b6403f5667232b310fb2acead3a892af69fb4dad42f0"
    sha256 cellar: :any_skip_relocation, monterey:       "01a4193e0c01cd6a02f5b6403f5667232b310fb2acead3a892af69fb4dad42f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "01a4193e0c01cd6a02f5b6403f5667232b310fb2acead3a892af69fb4dad42f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51bf887af5f6d2250308ba37273c3ffed4d0c3b8a400b8196bd376ec348337cb"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
