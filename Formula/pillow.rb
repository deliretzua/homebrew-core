class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/0f/8b/2ebaf9adcf4260c00f842154865f8730cf745906aa5dd499141fb6063e26/Pillow-10.0.0.tar.gz"
  sha256 "9c82b5b3e043c7af0d95792d0d20ccf68f61a1fec6b3530e718b688422727396"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "996a0e92f7957956425d372f0e7b896a487708449b29b3ab57e491535c2b0366"
    sha256 cellar: :any, arm64_monterey: "f8e584f42f026a77d4399c7881cc7578ce99a38d19132206ff81e10db001d1fa"
    sha256 cellar: :any, arm64_big_sur:  "d12d9ea98bbed38560d47fa547eb26f6405fead6fdcfa188be2837810fe204a4"
    sha256 cellar: :any, ventura:        "0da40f898faaea2de3cba4a6f6dc845cf9019a77d0b3a2cfc723de813d6bf7a8"
    sha256 cellar: :any, monterey:       "86053257f23602e70dc37b7335b59a1398a046f98a7a8ea39afa85ee29b3d796"
    sha256 cellar: :any, big_sur:        "99b13bbc6e1ffecd572e469199a58a89c8273269d99c6d6f17e8b69e3b3d285f"
    sha256               x86_64_linux:   "3df5a714b7a5df0347e6ab093ec7312b4ddb580cd68ab77d46f0b244f6a0ec5a"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "jpeg-turbo"
  depends_on "libimagequant"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libxcb"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "tcl-tk"
  depends_on "webp"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    build_ext_args = %w[
      --enable-tiff
      --enable-freetype
      --enable-lcms
      --enable-webp
      --enable-xcb
    ]

    install_args = %w[
      --single-version-externally-managed
      --record=installed.txt
    ]

    ENV["MAX_CONCURRENCY"] = ENV.make_jobs.to_s
    deps.each do |dep|
      next if dep.build? || dep.test?

      ENV.prepend "CPPFLAGS", "-I#{dep.to_formula.opt_include}"
      ENV.prepend "LDFLAGS", "-L#{dep.to_formula.opt_lib}"
    end

    # Useful in case of build failures.
    inreplace "setup.py", "DEBUG = False", "DEBUG = True"

    pythons.each do |python|
      prefix_site_packages = prefix/Language::Python.site_packages(python)
      system python, "setup.py",
                     "build_ext", *build_ext_args,
                     "install", *install_args,
                     "--install-lib=#{prefix_site_packages}"
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from PIL import Image
      im = Image.open("#{test_fixtures("test.jpg")}")
      print(im.format, im.size, im.mode)
    EOS

    pythons.each do |python|
      assert_equal "JPEG (1, 1) RGB", shell_output("#{python} test.py").chomp
    end
  end
end
