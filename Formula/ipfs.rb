class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.8.0",
      revision: "ce693d7e81e0206b3afbce30333c21a36a9f094b"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/go-ipfs.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "b5b83542ce69104ccd4cc5c3b24b04f9901da8ffb0f7f59ab29b1b0cc0b3a2c9"
    sha256 cellar: :any_skip_relocation, catalina:    "efa0829574ec0c1bb8191c3bfa0b5f146ad6a52123e6ac7aa66b318a5b2ef8a0"
    sha256 cellar: :any_skip_relocation, mojave:      "155e275561f4602feab774ea6519d61cab1bfb61a8fe33af94c8b8e5e5754d47"
    sha256 cellar: :any_skip_relocation, high_sierra: "0bb55579cf672cba14ddc8e8bb52c1db3ec691a9bc4d07935cc1f4021e7403b4"
  end

  depends_on "go@1.14" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ipfs/go-ipfs").install buildpath.children
    cd("src/github.com/ipfs/go-ipfs") { system "make", "install" }
    bin.install "bin/ipfs"

    cd("src/github.com/ipfs/go-ipfs") { bash_completion.install "misc/completion/ipfs-completion.bash" }
  end

  plist_options manual: "ipfs daemon"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/ipfs</string>
          <string>daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
