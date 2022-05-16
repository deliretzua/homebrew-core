class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.16.tar.gz"
  sha256 "ed16a1d751636d63f5b97f5c8e36024fd8aff5553057725ee2168e61e1f9d81a"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "922632c240429efdd5a4528b8ddddd1b29ec64866953451fc17c32b3075e7fb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bb9bbe31392eea714e54744ec873072b5c8ee6f902ff1a23ed99c9b5442ffcf"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a0558b391170eabdf2036cca5f3cde14130a3dd66b4f8407ffa1288eb47e37"
    sha256 cellar: :any_skip_relocation, big_sur:        "e45aafc4083ade260511c84cf32b06b39631eaecb017b2e8cdbb1fb7c1e4148b"
    sha256 cellar: :any_skip_relocation, catalina:       "04ab4a4791dc5a9441f619c0644ea7fe18e425598d8f2f0653f57468653a22fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a11f74146d1047fc55fd159f74278e9fc62352c1013189a81db93259e7815ba6"
  end

  depends_on "python@3.10" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"maturin", "completions", "bash")
    (bash_completion/"maturin").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"maturin", "completions", "zsh")
    (zsh_completion/"_maturin").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"maturin", "completions", "fish")
    (fish_completion/"maturin.fish").write fish_output
  end

  test do
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_bin
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system "python3", "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system "python3", "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
