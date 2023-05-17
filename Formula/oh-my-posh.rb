class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.4.4.tar.gz"
  sha256 "8e8aaaf70d8c498e7edae181829b342c8aca0edc7eda394076d5aaa13a2f3e3e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fba54cec39bb5116e5456270f0805aa09e65049c9884bd9544af14700ff460fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bf4c312a2393984536969fcea9b5abcc1030f0f3ac553e0b14408a1f4720565"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bb2418632d2d32958891a4a045c08dea22143e380c72d0ba1b02c5c92b0a41b"
    sha256 cellar: :any_skip_relocation, ventura:        "690fca104f375cfd9d13c0320e05354ee79bf1a9c63dd9aeec22d9a39196c816"
    sha256 cellar: :any_skip_relocation, monterey:       "b9334a8799bd5220b07545b4c2ccc856e55143f6bc8936347d1af61b797dce9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ddc1d1b19230a50748e883a67bd485e6644194b8044660d3df6b9d365427467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3d047633bb1c9e2395726546dafb2d9255c8dc8026190cdad24baf54a594ade"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
