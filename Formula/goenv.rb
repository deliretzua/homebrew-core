class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/2.1.0.tar.gz"
  sha256 "07081de6fa3d4716fa801ba6fce5c59478e8b195cb62597eaaa0cc281a2be77a"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97dfb34162d6520b35382ce101e68249b97aa89013d4a80c1db15e85457fedc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97dfb34162d6520b35382ce101e68249b97aa89013d4a80c1db15e85457fedc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97dfb34162d6520b35382ce101e68249b97aa89013d4a80c1db15e85457fedc8"
    sha256 cellar: :any_skip_relocation, ventura:        "f52e6e156c7fe8d43617142375bbfee711b33f6ef71718d900fee3e0cef763da"
    sha256 cellar: :any_skip_relocation, monterey:       "f52e6e156c7fe8d43617142375bbfee711b33f6ef71718d900fee3e0cef763da"
    sha256 cellar: :any_skip_relocation, big_sur:        "f52e6e156c7fe8d43617142375bbfee711b33f6ef71718d900fee3e0cef763da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1140f24fcd9743e4736127901900e0a7f045e0e3d1379ab48a3bd2bcb1d02b28"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
