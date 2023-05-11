class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/3.0.0.tar.gz"
  sha256 "5cc38017f2f52e3801deb62afb94ed5948c2435464ccc58e64430dcbb5201d82"
  license "MIT"
  head "https://github.com/kerl/kerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f0038da30e8c71d407e0a1ca1f7c1fa27fd614ba2ca02b0045cb4d962c8a409"
  end

  def install
    bin.install "kerl"
    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system "#{bin}/kerl", "list", "releases"
  end
end
