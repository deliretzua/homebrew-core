class Pixi < Formula
  desc "Package management made easy"
  homepage "https://github.com/prefix-dev/pixi"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "6b76294da2724604c308c60ca3a7a3654355157fa9df338cfd2b4e4b16fd2f96"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94b80a7236389763490e620986a8f63344cbcbd550e3af2e9575a8525e15ab0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3d69c524493bd8b63440933602ee7aa5acf1168e6895201c2356fe21b63c7b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cb1144b447b6ed8f0a8f85deaec4b8fc9cb267d3d2f969892002033d19ad942"
    sha256 cellar: :any_skip_relocation, ventura:        "e751f9d372e01e1f72532da8abdae7974464f0fa4f2476803fa824183210434b"
    sha256 cellar: :any_skip_relocation, monterey:       "fa1f1866678242ce036ebfd59039394e23d097664c669e4d7e88031b0c4ebbba"
    sha256 cellar: :any_skip_relocation, big_sur:        "c709067fd9efe5e87005e799409e91c76849896067ba7552472b0afc9dd64bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b783706de66e061c48be91925077efc58bf40034e1bf3f22d87913965b8054d9"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s", shells: [:bash, :zsh])
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip
    system "#{bin}/pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
