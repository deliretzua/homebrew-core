class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v2.3.0.tar.gz"
  sha256 "634f36891f38a6a7166f0ab7da34f50c1c92a9ccf2de2e27546570c83dd019a2"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d8ddb2e9b68a27ea7136b488fbaff87eac1194cf5a5852ead05e4c68cfcfd19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d8ddb2e9b68a27ea7136b488fbaff87eac1194cf5a5852ead05e4c68cfcfd19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d8ddb2e9b68a27ea7136b488fbaff87eac1194cf5a5852ead05e4c68cfcfd19"
    sha256 cellar: :any_skip_relocation, ventura:        "09ce47badd962dba4bef4f9d01e2b0276d0b5fa8e230bd23b122d5157e33d9ec"
    sha256 cellar: :any_skip_relocation, monterey:       "09ce47badd962dba4bef4f9d01e2b0276d0b5fa8e230bd23b122d5157e33d9ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "09ce47badd962dba4bef4f9d01e2b0276d0b5fa8e230bd23b122d5157e33d9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c22287138e6028cdfe0bc4afb8807a921ba9ecad9a2e0bcf0cdf774997e2935"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/v2/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end
