class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.16.3.tar.gz"
  sha256 "26636a2e2cc066184f12651ac6949f978fc041990dba73934960a4c9c1ea383d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "730361d730d684299daec515988a446da828f8c9ce0cbbcb9ca411d22989be4f"
    sha256 cellar: :any_skip_relocation, big_sur:       "57a313186f3cf80ac7985f1f86fe415a3a9f179044fa5db2333460043b1809f4"
    sha256 cellar: :any_skip_relocation, catalina:      "57a313186f3cf80ac7985f1f86fe415a3a9f179044fa5db2333460043b1809f4"
    sha256 cellar: :any_skip_relocation, mojave:        "57a313186f3cf80ac7985f1f86fe415a3a9f179044fa5db2333460043b1809f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e88b8b7697764e9336ac1f849be0e8647627e38299671b208689949071bb0192"
  end

  depends_on "python@3.9"

  def install
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix/"var/spack/junit-report" unless (prefix/"var/spack/junit-report").exist?
  end

  test do
    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack list zlib")

    # Set up configuration file and build paths
    %w[opt modules lmod stage test source misc cfg-store].each { |dir| (testpath/dir).mkpath }
    (testpath/"cfg-store/config.yaml").write <<~EOS
      config:
        install_tree: #{testpath}/opt
        module_roots:
          tcl: #{testpath}/modules
          lmod: #{testpath}/lmod
        build_stage:
          - #{testpath}/stage
        test_stage: #{testpath}/test
        source_cache: #{testpath}/source
        misc_cache: #{testpath}/misc
    EOS

    # spack install using the config file
    system bin/"spack", "-C", testpath/"cfg-store", "install", "--no-cache", "zlib"

    # Get the path to one of the compiled library files
    zlib_prefix = shell_output("#{bin}/spack -ddd -C #{testpath}/cfg-store find --format={prefix} zlib").strip
    zlib_dylib_file = Pathname.new "#{zlib_prefix}/lib/libz.a"
    assert_predicate zlib_dylib_file, :exist?
  end
end
