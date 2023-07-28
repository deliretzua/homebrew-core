class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/2.1.1.tar.gz"
  sha256 "4879470b41ea1ca4dccb8f2889f5bd37355526a106db434650be70cb9f5c4517"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e92739b079b432d38a9c039e5d49deae971896d151070f060b171fc43766ee6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e92739b079b432d38a9c039e5d49deae971896d151070f060b171fc43766ee6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e92739b079b432d38a9c039e5d49deae971896d151070f060b171fc43766ee6"
    sha256 cellar: :any_skip_relocation, ventura:        "cd7c072cee0bd9f2779332ac1c7dfcbdd950cdfe7ba3469d7b0dedb8b731f7b0"
    sha256 cellar: :any_skip_relocation, monterey:       "cd7c072cee0bd9f2779332ac1c7dfcbdd950cdfe7ba3469d7b0dedb8b731f7b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd7c072cee0bd9f2779332ac1c7dfcbdd950cdfe7ba3469d7b0dedb8b731f7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd55ab1f28ed3115f66f341f124354f3f88eb0f6b0916a012953655ec839e6ac"
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
