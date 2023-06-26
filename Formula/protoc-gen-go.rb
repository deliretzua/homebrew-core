class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/v1.31.0.tar.gz"
  sha256 "96d670e9bae145ff2dd0f48a3693edb1f45ec3ee56d5f50a5f01cc7e060314bc"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69c99bc05e35d39bc9ddffcb0b14983b54b296e83377c87b7c2ace8c0f4eb6a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69c99bc05e35d39bc9ddffcb0b14983b54b296e83377c87b7c2ace8c0f4eb6a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69c99bc05e35d39bc9ddffcb0b14983b54b296e83377c87b7c2ace8c0f4eb6a0"
    sha256 cellar: :any_skip_relocation, ventura:        "42103b258add7d711e4d8b926e2f39dd0ebd5b96ba35a3d22a169bd83c4c396e"
    sha256 cellar: :any_skip_relocation, monterey:       "42103b258add7d711e4d8b926e2f39dd0ebd5b96ba35a3d22a169bd83c4c396e"
    sha256 cellar: :any_skip_relocation, big_sur:        "42103b258add7d711e4d8b926e2f39dd0ebd5b96ba35a3d22a169bd83c4c396e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82977e2b8abfcc63acc3a410641a46b527974984216472171ae18d0b1d3245f6"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
    prefix.install_metafiles
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      option go_package = "package/test";
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "--go_opt=paths=source_relative", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
