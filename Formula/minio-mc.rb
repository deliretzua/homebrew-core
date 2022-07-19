class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-07-15T09-20-55Z",
      revision: "48e9183957fce660dcc32a36bbee6f3ee4a9d0e9"
  version "20220715092055"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f48d7865d2ee3a1d953398c6870fd19618b762299cf426dc0534c81d95c9f33a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12a4bc1ae30f69a7c0859ce1544917cccc563a3128315b7c1c63f5a501ccb576"
    sha256 cellar: :any_skip_relocation, monterey:       "3555679ba27d8d01504f6fa9f154a6b50c7cc842c2c92bb202e52535a1201a8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ed0cff6ddeafbc36979fc08b8c3cfad4be819c3292df32902aaca16f234f3dc"
    sha256 cellar: :any_skip_relocation, catalina:       "dd179f9df5743d5ffdb926b4bf1e0952055f7d00ef8e97b66e1715374a0cddd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a57dcf664057d0cba9311bc130b79c055ec6e84b3c84f48fac258872257829a5"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

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
