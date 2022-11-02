class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.23.tar.gz"
  sha256 "2caa55aae977831705acb17482538d93c8711564d2be1af020ca860a0beef00f"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95ccaef5d22d7a954d2b4a4edc9e1e8121861e67b4bb05d02710c45ca68d0540"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad1beaf6fd39f64a7111e113b4d9998f191a12d1e99a8138ab6625c3002dbaae"
    sha256 cellar: :any_skip_relocation, monterey:       "1591d2b01f6a23be419306b6e85b153991a28d0e48269439b90ef2bd23522ff7"
    sha256 cellar: :any_skip_relocation, big_sur:        "938c2885cda585fe91efe1ee22a4e00df8064db5983afd8bd61704071363f7fe"
    sha256 cellar: :any_skip_relocation, catalina:       "04f273fab672d34505d521b06245f751d2ece3c54d7f585f3f61413be1bcfbd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d04cb5b4a7113079c178c7177e4854e907b967678e998d728988e792b08e5c7a"
  end

  depends_on "go" => :build

  resource "homebrew-testdata-OneMessage" do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
    sha256 "16e841dbae8aae5cc6824a63379c838dca2e81598ae08461bdcc4e7334e11da4"
  end

  resource "homebrew-testdata-OneAttachment" do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneAttachment/OneAttachment-ax-pad-st-sum.mcap"
    sha256 "f9dde0a5c9f7847e145be73ea874f9cdf048119b4f716f5847513ee2f4d70643"
  end

  resource "homebrew-testdata-OneMetadata" do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMetadata/OneMetadata-mdx-pad-st-sum.mcap"
    sha256 "cb779e0296d288ad2290d3c1911a77266a87c0bdfee957049563169f15d6ba8e"
  end

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
    generate_completions_from_executable(bin/"mcap", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/mcap version").strip

    resource("homebrew-testdata-OneMessage").stage do
      assert_equal "2 example [Example] [1 2 3]",
      shell_output("#{bin}/mcap cat OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").strip
    end
    resource("homebrew-testdata-OneAttachment").stage do
      assert_equal "\x01\x02\x03",
      shell_output("#{bin}/mcap get attachment OneAttachment-ax-pad-st-sum.mcap --name myFile")
    end
    resource("homebrew-testdata-OneMetadata").stage do
      assert_equal({ "foo" => "bar" },
      JSON.parse(shell_output("#{bin}/mcap get metadata OneMetadata-mdx-pad-st-sum.mcap --name myMetadata")))
    end
  end
end
