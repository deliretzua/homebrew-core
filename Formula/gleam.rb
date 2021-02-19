class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.14.0.tar.gz"
  sha256 "2795720f35994710094847990234da8d38e6e43f0810b69c6f45087547d2a4d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "507e4e923dbd2360124ab6753a8091427a0ce84bf95d66911d82b31d57dad697"
    sha256 cellar: :any_skip_relocation, big_sur:       "55010c559d4fbbe94940136eb1667fb3b67c79bd213e17c7b30d15499055e4ed"
    sha256 cellar: :any_skip_relocation, catalina:      "3469ba547cef8f9ff75f009e80861f5e7710d237a8cc7ebfc5b575f8edee7e6d"
    sha256 cellar: :any_skip_relocation, mojave:        "41f34ecdf5ffacfc732a6685bba365a43e15cab4ba21679b9ae5a86ba0eea460"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
