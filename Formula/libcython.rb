class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/7f/a2/fd5ced5dd33597ef291861bfadd46820de417b41bcb6ca2fa0b5f6fa8152/Cython-3.0.0.tar.gz"
  sha256 "350b18f9673e63101dbbfcf774ee2f57c20ac4636d255741d76ca79016b1bd82"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3768d1e375ec0af6c0b22aafe3d859274392676a115f9ffaac61893633a8c5a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4afcd7325d160c1d11394463614bb705aa7e14831f483930a09dfbb6acafcabc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4661884bed971857eff3f528480847f0baa1638c58282499b63d979049e2415"
    sha256 cellar: :any_skip_relocation, ventura:        "eb4f5cf32cbbc7c614904a0c8c1cbdd29ea952f068e973c2167925dd05284e2b"
    sha256 cellar: :any_skip_relocation, monterey:       "db83a1b4858cf78c463deb79d8b235b366c1ef68ef6fe5d83019172e891296df"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e03b6bb0f9073a15e3aeea2c80dc3c2f0141967de7de9586a54eb4a7c3094d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a19d2335f64834ad41c25ca2ce7c48e1fa8cb8bc64af0cf3728d6d3059934584"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version)
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, *Language::Python.setup_install_args(libexec, python)
    end
  end

  test do
    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    pythons.each do |python|
      with_env(PYTHONPATH: libexec/Language::Python.site_packages(python)) do
        system python, "setup.py", "build_ext", "--inplace"
        assert_match phrase, shell_output("#{python} -c 'import package_manager'")
      end
    end
  end
end
