class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.6.1/nuget.exe" # make sure libexec.install below matches case
  sha256 "d9e2d4db12ff444b684a40cbeb2775a2adf3f65980e8a55f3c006faec2b89b7c"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    regex(%r{"url":\s*?"[^"]+/v?(\d+(?:\.\d+)+)/nuget\.exe",\s*?"stage":\s*?"ReleasedAndBlessed"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2d8ab4f8fc85dd381657e02af4aa7dfea4a1e527fcd79a164f5e5297be3338"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e2d8ab4f8fc85dd381657e02af4aa7dfea4a1e527fcd79a164f5e5297be3338"
    sha256 cellar: :any_skip_relocation, ventura:        "1e2d8ab4f8fc85dd381657e02af4aa7dfea4a1e527fcd79a164f5e5297be3338"
    sha256 cellar: :any_skip_relocation, monterey:       "1e2d8ab4f8fc85dd381657e02af4aa7dfea4a1e527fcd79a164f5e5297be3338"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e2d8ab4f8fc85dd381657e02af4aa7dfea4a1e527fcd79a164f5e5297be3338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11616721cea5ce9d7707e7c2965ead699197edc7eb55c54ee7e659d5192379dc"
  end

  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~EOS
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end
