class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v3.0.6.tar.gz"
  sha256 "592f230e81ccda26f3366a07501278d7419bc7a5ac48aaa6a725a1b806b15a9b"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2b1e1d23423c152acb05f34a26cd5e6c5480116bc63a2868cef9659f1a42837"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c42d0a7a535288bd8479f5071e8a973e8027bcaa259437667b20c50a2c4b9285"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bb8a9116732629a9698c44f2f533560a325dcd7a1eadbfbc7473598e07889da"
    sha256 cellar: :any_skip_relocation, ventura:        "d6e1ee0027d66edcb184e0f8653d7bcea684dd511881c5bab69876d053dff8a6"
    sha256 cellar: :any_skip_relocation, monterey:       "d6e1ee0027d66edcb184e0f8653d7bcea684dd511881c5bab69876d053dff8a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a714d0ecddc788eae807a62b55dcd6f7d5d864a3b0da91ba3446dfb5d6b9337"
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
