class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-01-25T19-56-04Z",
      revision: "cd7a5cab8a14bb335343a0580b6fcd54d815133a"
  version "20220125195604"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ae267eae7c11b86ada485bb19c9de84faadb5dda44a8a711de446d7a9220014"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd42d8f4a4facb35069707e5e7b777281fd5bad49a5c5f9407a921cfa24117ec"
    sha256 cellar: :any_skip_relocation, monterey:       "b4187ce0d92bd2d3560b1717e620b3524ce0e5278f668bfcaa4fd7bb048a08d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c77c4d50a53aa48199121443f785f3335cd347e914b5946456faa62709af5cc"
    sha256 cellar: :any_skip_relocation, catalina:       "47ffbbff1a51a4583faadabc2e9f304c21a6c18cf566d755e92bf87fb2559388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "627da0fe1995648af7194f9f5313b2478d92a7bf3a2c8f871b8ce14ff362b720"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")

    assert_match "minio gateway - start object storage gateway",
      shell_output("#{bin}/minio gateway 2>&1")
    assert_match "ERROR Unable to validate credentials",
      shell_output("#{bin}/minio gateway s3 2>&1", 1)
  end
end
