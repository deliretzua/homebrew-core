class Aftman < Formula
  desc "Toolchain manager for Roblox, the prodigal sequel to Foreman"
  homepage "https://github.com/LPGhatguy/aftman"
  url "https://github.com/LPGhatguy/aftman/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "2c4f191bfce631abff185a658b947105055da687c409e09ea80786be4c32b75e"
  license "MIT"
  head "https://github.com/LPGhatguy/aftman.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"aftman.toml").write <<~EOS
      [tools]
      rojo = "rojo-rbx/rojo@7.2.1"
    EOS

    system bin/"aftman", "install", "--no-trust-check"

    assert_predicate testpath/".aftman", :exist?
  end
end
