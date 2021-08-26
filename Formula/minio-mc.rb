class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-07-27T06-46-19Z",
      revision: "addaf66de8af5d865a6102320727e8a5dbcacdb6"
  version "20210727064619"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2063b187b7dbb836f818fcec3a4639d4e64c96d9d1f6d939e506762f7d369250"
    sha256 cellar: :any_skip_relocation, big_sur:       "a862123c9c605ffe1bdbd4b5b3c627f6f61383737ad72e9a2504a4800d4fe89f"
    sha256 cellar: :any_skip_relocation, catalina:      "8675c966db80e5f3ea209ca100f24732df12bb5076c6aabb2231dd36b79f8154"
    sha256 cellar: :any_skip_relocation, mojave:        "866b93e19bfe8a836d4c9af018977511cefd46cfbd463b9b30102b410a44589a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec747d29ca4c52766473c86db01955140754cb134d32a98407c04188369776f3"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/minio/mc/commit/855333e4ab24804dd3dcd38988ceaed112ee62f9.patch?full_index=1"
    sha256 "c00d331fd8d420105356d004aeecd17ef4c6332796f53a3e547218b4de7dbd41"
  end

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
