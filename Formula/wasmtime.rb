class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v9.0.1",
      revision: "1bfe4b551baaec3ed778fe9e63327ca35a36ae88"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dc6a2ee39ab0700f4fb510b397c6f463e855bc70e5516d0f1621a8d02c23772"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "086e421edc07fd4534da70ab0c2d438670beb0c9ff78683b09f8439232704e5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5feae8b8f5e081432ffa3cfbe2c84086556fed005bb7c1ff4532dceae276ab8e"
    sha256 cellar: :any_skip_relocation, ventura:        "3318f168c71c462c7d03e822a9b14c6f26232f4be35808da4cb0e3f77126660e"
    sha256 cellar: :any_skip_relocation, monterey:       "59689571367c646b5f00614ea4b8855341b4e6a4db7b8072e1289410544bfab1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ad69cf6d335b05eae41b64cb1b1bb2bdf77cd34908fca17606776af34fefcc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92fd93e01d55529fa0ea4d2f107999e8731b76eb4e9262e03af358b517bf7bfd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
