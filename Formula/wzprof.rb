class Wzprof < Formula
  desc "Profiling for Wazero"
  homepage "https://github.com/stealthrocket/wzprof"
  url "https://github.com/stealthrocket/wzprof/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "a5ebae104121737243ba2e90cd21d468133e7e0683b5ac880ebf3abecce90089"
  license "Apache-2.0"
  head "https://github.com/stealthrocket/wzprof.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/wzprof"
  end

  test do
    resource "simple.wasm" do
      url "https://github.com/stealthrocket/wzprof/raw/c2e9f22/testdata/c/simple.wasm"
      sha256 "f838a6edabfc830177f10f8cba0a07f36bb1d81209d4300f6d41ad2305756b3a"
    end

    testpath.install resource("simple.wasm")
    expected = <<~EOS
      start
      func1 malloc(10): 0x11500
      func21 malloc(20): 0x11510
      func31 malloc(30): 0x11530
      end
    EOS
    assert_equal expected, shell_output(bin/"wzprof -sample 1 #{testpath}/simple.wasm 2>&1")

    assert_match "wzprof version #{version}", shell_output(bin/"wzprof -version")
  end
end
