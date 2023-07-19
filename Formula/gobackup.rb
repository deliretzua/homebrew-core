class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v2.5.1.tar.gz"
  sha256 "9343911d3bb92eee3f2ae7be919b41520000550b984ffe681c46297925d2d440"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "112e089ce2e4f16d8deb16f23c414445f85982fed0fff4e11625782175599fe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "112e089ce2e4f16d8deb16f23c414445f85982fed0fff4e11625782175599fe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "112e089ce2e4f16d8deb16f23c414445f85982fed0fff4e11625782175599fe2"
    sha256 cellar: :any_skip_relocation, ventura:        "895870132677e24d8be174ab188b52767f9444844b14b09e1dfd2adbdd11c7ee"
    sha256 cellar: :any_skip_relocation, monterey:       "895870132677e24d8be174ab188b52767f9444844b14b09e1dfd2adbdd11c7ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "895870132677e24d8be174ab188b52767f9444844b14b09e1dfd2adbdd11c7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05378f8a158b4727372e5a6f970c26a51391f50d53a14f32477f2dad7c3dd8e4"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    revision = build.head? ? version.commit : version

    chdir "web" do
      system "yarn", "install"
      system "yarn", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{revision}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobackup -v")

    config_file = testpath/"gobackup.yml"

    config_file.write <<~EOS
      models:
        test:
          storages:
            local:
              type: local
              path: #{testpath}/backups
          archive:
            includes:
              - #{config_file}
    EOS

    out = shell_output("#{bin}/gobackup perform -c #{config_file}").chomp
    assert_match "succeeded", out
    tar_files = Dir.glob("#{testpath}/backups/*.tar")
    assert_equal 1, tar_files.length
  end
end
