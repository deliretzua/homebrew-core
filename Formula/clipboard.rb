class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://github.com/Slackadays/Clipboard/archive/refs/tags/0.7.0.tar.gz"
  sha256 "56eb36ffcc0aa52e96dedcdc9c31a09871b442b118a75e2fd56a83c06bb71b66"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "567881d4b39b83a7ec810cfebe0b7bfc6828164e497e791e019f50cdbb0dab62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d56b78f9633fed6e047f1b595a09c627ffb48bf2b0ad68a351045ea3c9449fa"
    sha256 cellar: :any_skip_relocation, ventura:        "5ba34ebe7146091c0581985c61a3160614dd49490cb6d32bb9ede23b1a039492"
    sha256 cellar: :any_skip_relocation, monterey:       "4f605675ed9fc4989bd2c7766a1ed30e75b7faf761898ed3aff8580d112be331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826afa3681f29ed730159a7d0ca15ac0cedad1a60ec82b75fe9f576b2882df55"
  end

  depends_on "cmake" => :build
  depends_on macos: :monterey

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "wayland-protocols" => :build
    depends_on "libx11"
    depends_on "wayland"
  end

  fails_with :clang do
    build 1300
    cause "Requires C++20 support"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CLIPBOARD_FORCETTY"] = "1"
    ENV["CLIPBOARD_NOGUI"] = "1"
    system bin/"cb", "copy", test_fixtures("test.png")
    system bin/"cb", "paste"
    assert_predicate testpath/"test.png", :exist?
  end
end
