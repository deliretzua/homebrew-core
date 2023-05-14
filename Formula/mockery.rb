class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "0ac5973e8fb297b0ca8f613ef79590e383010348d460dfc8055a8a0666b17a14"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc136e1fba005a46e3fff771530663265d34db5295ce8e4c237333a73ad53513"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4d7ca9f662cd510a9813e2b8b816a5b2f33775770385ddce526a3f7b13e9625"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23daeb955bc5241acf88eb349b111a68acd287b45e253af79108465213ae0503"
    sha256 cellar: :any_skip_relocation, ventura:        "3ccd4ad82a2121b9db1a0a92e3efc04bc660fbb05415d7683b32144c5a177100"
    sha256 cellar: :any_skip_relocation, monterey:       "9617382c1bd3c4ba900b0f4ecb3b5c248446a07cfe4a3e8666d941c3791e1635"
    sha256 cellar: :any_skip_relocation, big_sur:        "013fd89f66cf971e55f2f42ee3e855cdddde18cfb935d2f3efd3d30ab9804369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e2425f6577bb5cd03b7e2435f3ec7c465e882a5c2e06a4036377be903076a32"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
