class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-src.zip"
  sha256 "4c1100f5170ae1c3bd1b4fd9458b3b02ae841aefbfc41514887b80996436dee2"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/premake/premake-core.git", branch: "master"

  livecheck do
    url "https://premake.github.io/download/"
    regex(/href=.*?premake[._-]v?(\d+(?:\.\d+)+(?:[._-][a-z]+\d*)?)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "055233cb2cf7298878c1feb4918b610af537a4e625dc12559238f77918cf6f07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e19935725d14811b05a4e4d0c6673627a8bcc020e0e63551f1d32b92809320e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb310032324c501da5115145b6d686b6e6782d9946c9ddd3d27886348a8be131"
    sha256 cellar: :any_skip_relocation, ventura:        "821fd285a0d500c778587b7d4a0d3f52b375f3edd39547862f140d90a87b886a"
    sha256 cellar: :any_skip_relocation, monterey:       "72260a33d5a3b6b0181fd3ab23f153e2d6e117633fa53fb5c51e011eadd2caaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "b241e62ee709c21745342d0935fd968ca4ce1df40449d15f900b7a22f9bfdd9d"
    sha256 cellar: :any_skip_relocation, catalina:       "c93b55a816857f51075a47a4d41436376020f0a68d8af104a298bb91909d6873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f18473b6bf3eb65b2b8e36f35e2166bfe6f859abae5e63806f7bcb5ec675f2bf"
  end

  on_linux do
    depends_on "util-linux" # for uuid
  end

  def install
    # Workaround for Xcode 14.3
    # upstream issue, https://github.com/premake/premake-core/issues/2092
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    if build.head?
      platform = OS.mac? ? "osx" : "linux"
      system "make", "-f", "Bootstrap.mak", platform
      system "./bin/release/premake5", "gmake2"
      system "./bin/release/premake5", "embed"
      system "make"
    else
      platform = OS.mac? ? "macosx" : "unix"
      system "make", "-C", "build/gmake2.#{platform}", "config=release"
    end
    bin.install "bin/release/premake5"
  end

  test do
    expected_version = build.head? ? "-dev" : version.to_s
    assert_match expected_version, shell_output("#{bin}/premake5 --version")
  end
end
