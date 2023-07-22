class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "612113c2b43f26b5b72262d4c964a98c153562cb7cbb27204900c9c72fbc0bdd"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f609f11ec1414b340ef077f1acb99f0cdb3ed0f5402daed0f6cfc285b5e341b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a425685fe0f4cd70791a2847d2e77ab5a7434633d65b16be52778eff5f464b97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6160d8e241d308af0dcbcd3f9fe73d051d1894120e0a6f6359e4007dc6a072a"
    sha256 cellar: :any_skip_relocation, ventura:        "7cee6991e82c59faa5bf00dca0d944ebd43cfd84ce02c6d5f8d6efc68622a7fb"
    sha256 cellar: :any_skip_relocation, monterey:       "43d2f063ef46ade5785e1ddf71a2b2a83f0c53a393a09b977133499e289aeb13"
    sha256 cellar: :any_skip_relocation, big_sur:        "83cefe67c4d4085fccbd810ac6b725ec8e5d4927219c1b29864609040e18a469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d6c3c7a14c61579d766fd1ae798b9b1230cde9c84ab602d97620d8d2d0eb239"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

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
        license = "MIT"
      EOS

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
