class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v3.0.6.tar.gz"
  sha256 "592f230e81ccda26f3366a07501278d7419bc7a5ac48aaa6a725a1b806b15a9b"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9b18a5d4f4b9c8fcc19a2b1635f78c80db76dd2cf77c47ea07f03a5a11df58e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73f1d5408df9e2f44a5dded487f3859fb71e2762a78c25548a96895c971a80ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d735c8e48e17d9ee934e486af196480bf645ca9f0e22bf183349da8c2ed14042"
    sha256 cellar: :any_skip_relocation, ventura:        "f9c51e019ba7e1b72e0177465240e18cc035024d11ddd2f11bc91e13cca58461"
    sha256 cellar: :any_skip_relocation, monterey:       "7686b71b6c1b8cba0b7cb1ba473baab6e9f113321fad263bfdf9b4700e843838"
    sha256 cellar: :any_skip_relocation, big_sur:        "22bf841a5d444c33f481ba2a190a67bcae2e2d8b714d0fc63e0c6ad81c6508b3"
  end

  depends_on "rust" => :build
  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    File.write("test.svg", '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" /></svg>')

    # folderify applies the test icon to a folder
    system bin/"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
