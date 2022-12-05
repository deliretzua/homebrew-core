class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle/archive/v0.21.0.tar.gz"
  sha256 "e214b471319b0b3acc62a7105e06fc74b116a546ac5cce8cd4d3c18f0e6ff6a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "07826c6a2d070c0043ddb6e2ffe17b7a3e3f0209c90baf229a7254eadfe1d132"
    sha256 cellar: :any, arm64_monterey: "0e66627ef1680983c0cc42009f236d4cfca6cbfb5cf0fe3a5cddbaa9a063f0ae"
    sha256 cellar: :any, arm64_big_sur:  "322645f16215f9784d162de9552e533131fff4235dfd421e46c3e3ced208a26f"
    sha256 cellar: :any, ventura:        "fcc83c3d71dba3f876c465000371096270ab1322f4b755181e3647e2ceebb809"
    sha256 cellar: :any, monterey:       "1ec0bd0e6b409a8f65bc3741ab7170e2346c838b96e3407bac5e8b815aca8f1f"
    sha256 cellar: :any, big_sur:        "21e3fc48210529852cf33cae4fe2c5a2937920321e7d03b76b93d775d35c0e9a"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    # Avoid building a universal binary.
    swift_build_flags = (buildpath/"Makefile").read[/^SWIFT_BUILD_FLAGS=(.*)$/, 1].split
    %w[--arch arm64 x86_64].each do |flag|
      swift_build_flags.delete(flag)
    end

    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}", "SWIFT_BUILD_FLAGS=#{swift_build_flags.join(" ")}"
    bin.install "./Generator/bin/needle"
    libexec.install "./Generator/bin/lib_InternalSwiftSyntaxParser.dylib"

    # lib_InternalSwiftSyntaxParser is taken from Xcode, so it's a universal binary.
    deuniversalize_machos(libexec/"lib_InternalSwiftSyntaxParser.dylib")
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      protocol ChildDependency: Dependency {}
      class Child: Component<ChildDependency> {}

      let child = Child(parent: self)
    EOS

    assert_match "Root\n", shell_output("#{bin}/needle print-dependency-tree #{testpath}/Test.swift")
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
