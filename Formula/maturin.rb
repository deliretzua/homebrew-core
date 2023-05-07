class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "15ab24cc43da24ceca5175847a43ac59b31447b8b545cecca902d219110faee9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d6a9fe1d3c41e8fe8ec4125ec4ffb3d93d4f527adb617f59e60f1fff616b5b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32246be1599e70b9b0eb3fcabe9b1756cd28a77edfc42cd30c442a1d1b44a2aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "610ef03bedca433e3feee6f6895c2b593c9ec0cdceaada55c004558ba8713154"
    sha256 cellar: :any_skip_relocation, ventura:        "504491010dd6b0a4ced5ec03ed5e1e14a69c4f7c52dee5a8be197a8a78bd4576"
    sha256 cellar: :any_skip_relocation, monterey:       "a451b9f1db6da6ded8f125b6953f8caa38cb5b088ee128cb96977944ac3d0ddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "806d1ce252470a9efc7212eb347aa6f42c92c44b40ff0764ff5aa0c29d282094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e295bf7c5cde6ee9bd99afc56f3388a1f591df6869beea9ff59707dc78cc8500"
  end

  depends_on "python@3.11" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
