class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.45.0.tar.gz"
  sha256 "92d2676e46447a62103dd17b7a5cb17ab7054dc2878be345a846fb03d8e6bcf5"
  license "Apache-2.0"
  head "https://github.com/leanprover-community/lean.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version == "9.9.9" # Omit a problematic version tag

        version
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "9caf0f417f32915d8434f6e863549c0472b395797daa93c54b214fea0aff4d47"
    sha256 cellar: :any, arm64_big_sur:  "299dcc46b2a7f4c87cc1c321a15af9a95a5eee099ddc69860ccb255600ad61f1"
  end

  depends_on "cmake" => :build
  depends_on "coreutils"
  depends_on "gmp"
  depends_on "jemalloc"
  depends_on macos: :mojave

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "elan-init", because: "`lean` and `elan-init` install the same binaries"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -DCMAKE_CXX_FLAGS='-std=c++14'
    ]

    system "cmake", "-S", "src", "-B", "src/build", *args
    system "cmake", "--build", "src/build"
    system "cmake", "--install", "src/build"
  end

  test do
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree (α : Type) : Type
      | node : α → list tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a :=
      begin
          intro h, cases h,
          split, repeat { assumption }
      end
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"leanpkg", "help"
  end
end
