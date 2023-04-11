class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "e4f3491ad342a662fda838c34de03c47ef2fa3019952adbfb94fe4109c06ccf2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e159cf63f8888d361a215382ab14c400d472f54de8a73c9e695b3f2c74b638af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9847a0302ba5d6df3a4989679225c4647d22acc15a524b38e95c74af277b428e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ca5198178ccdba017da16bc6e26281fdbc4e629fb6fd5b5d0e7393606ae6140"
    sha256 cellar: :any_skip_relocation, ventura:        "eadc032a9ac8c11a4a1fa67d9e3ea8aff41c01e2513affb6648a924c0c4a47e7"
    sha256 cellar: :any_skip_relocation, monterey:       "9e2ac6836b2a0d13f79f3121f14210cd026d83d7cdbb826ae6e98754dc312ede"
    sha256 cellar: :any_skip_relocation, big_sur:        "899aa1bcad37dc36bdc468d865da632e6fd7c9a3c16ee884437534b4db0d52c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e94562c75dfbe7d4ea00d19261faa21db3b041c51d44fdd9dfca7bad134ab8a"
  end

  depends_on "rust" => :build
  depends_on "rustfmt"

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")
  end

  test do
    (testpath/"cool.h").write <<~EOS
      typedef struct CoolStruct {
          int x;
          int y;
      } CoolStruct;

      void cool_function(int i, char c, CoolStruct* cs);
    EOS

    output = shell_output("#{bin}/bindgen cool.h")
    assert_match "pub struct CoolStruct", output
  end
end
