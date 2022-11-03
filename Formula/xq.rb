class Xq < Formula
  desc "Command-line XML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v0.0.8",
      revision: "b249d1a8470c10d950e404f926794bd5ba7f7c3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4191730c263fa0389e7aa8a7be8ccd50075c28f6a52f47585d3bf94b01e4a6d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36a8d6d20c8ae3734bb749e080d3a5b665c2563824a1bc7bb4f574e39cf700f2"
    sha256 cellar: :any_skip_relocation, monterey:       "f62cc6bdb06dda94da9bb5ce040497833b01933770f200dd973d88d8ccba9a1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1559f646a54240384d8931cb155689bf7ff40aebf113826e8f453e1ba25082a"
    sha256 cellar: :any_skip_relocation, catalina:       "0718b2b10cd49943c30fd6b24dd19411f7f431b204d0c0b4f44eacc210959b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "905d5abe7415a7cfc8b93e5df66e299e68c762db654ca1c77bc1146fecb01c55"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.commit=#{Utils.git_head}
      -X main.version=#{version}
      -X main.date=#{time.rfc3339}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    version_output = shell_output(bin/"xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end
