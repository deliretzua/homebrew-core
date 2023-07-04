class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/1.1.7.tar.gz"
  sha256 "7f61937d5dfce776ef7dcb86a8a97f6db5701a7a522474b99ce2ae36ad9d6248"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cpz")
    system "cargo", "install", *std_cargo_args(path: "rmz")
  end

  test do
    system bin/"cpz", test_fixtures("test.png"), testpath/"test.png"
    system bin/"rmz", testpath/"test.png"

    assert_match "cpz #{version}", shell_output("#{bin}/cpz --version")
    assert_match "rmz #{version}", shell_output("#{bin}/rmz --version")
  end
end
