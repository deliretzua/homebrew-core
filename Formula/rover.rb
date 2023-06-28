class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "e46f18e6274a6a769a2bebffa24f9a9d7fd9b7228c9008b1afa2ddc1055f76f6"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "562017a2d10b311d4c329e9581d39b3622a5a349ab067f900bc948a00cbfef1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e72433c0c684c3ccdd7ab18a1eb3dd4ba2cb06a24188e44f035585f60b66c6ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c084fc203fb9a2b8d40daf208e433184f9da795d7ecdee6a51274fd30e3d3d8"
    sha256 cellar: :any_skip_relocation, ventura:        "f01c4d068534a2c54e92a8c07c01c2e8cc58fa84fd6d20cc7fa72d1f95059140"
    sha256 cellar: :any_skip_relocation, monterey:       "4a35f8c5e77504c378fb1f3d79be2bf2f0695870a6ea118b42e627b07d2ba948"
    sha256 cellar: :any_skip_relocation, big_sur:        "165c04fe503b6075ce44e6e3ee9604e93ba6c556f8d78351d6556fb07ed0a3a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00fdc7dde5593c22bc148c1d2c19c66f0f7bc894e18043f7e0acaaaa6c800e6"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
