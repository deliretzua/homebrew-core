class Mods < Formula
  desc "GPT-4 on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2e855a621406289b374068ebcca4a9613d1c64ce64754695c269322698ce73e9"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=homebrew
      -X main.date=#{time.iso8601}
      -X main.builtBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin/"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "Invalid OpenAI API key", output

    assert_match version.to_s, shell_output(bin/"mods --version")
  end
end
