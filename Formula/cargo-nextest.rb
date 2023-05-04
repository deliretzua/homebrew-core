class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.52.tar.gz"
  sha256 "bf1726e5a57d734093abca10e26f1c9201ff606f8f35b294f644efa42a07c74b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f558ec574934820fe7a03199fd5a11972b86ecbcdb6d0f86bfeb43223ae4a440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08f0781b4ce0883cfeb30575acacd476dde338256a033234bc4bc9727822d312"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a56cd7cddb3a08819604d58b89732e4e916aee02eeb5ec1d1b1c3edad25f3f5"
    sha256 cellar: :any_skip_relocation, ventura:        "05c3cb0709acead969eee4b1281f81b9430a676e21640de1144d8e3c7beea8e5"
    sha256 cellar: :any_skip_relocation, monterey:       "a19e7253183569c362ff9448044920a8e17025dc7190c9aac93cbe1f6b575d43"
    sha256 cellar: :any_skip_relocation, big_sur:        "de08de25478eedb247dcb9230ccf26d0fa91c6da4b8d1460233db06b6a9c9de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d2342b84657e715561faaa0604bd063acc05acde62118f346c9b3d2764d8b78"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 tests across 1 binaries", output
    end
  end
end
