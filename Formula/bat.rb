class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.18.0.tar.gz"
  sha256 "49d1b95250050df47753c213b5e48953a029c9e74753cef371051b14c9d629b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "48a05609d5738b5f9fd8c886aa9e6915b2ad7e0a4148979a026ca157b6e8e199"
    sha256 cellar: :any_skip_relocation, big_sur:       "2154428e50a347937148312bd787b422fd21b1135b58bf9362aebd3ea08c25d8"
    sha256 cellar: :any_skip_relocation, catalina:      "37950cb2429346cacc2dd0a9902b71eb958fb9531114d3606bdc3acfdd4dc3c2"
    sha256 cellar: :any_skip_relocation, mojave:        "9f4df3e3e829e59ec2d196be8a494d60f9f68ef7f9f769adfb018f75148677be"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
