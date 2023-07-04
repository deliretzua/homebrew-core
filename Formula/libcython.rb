class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/38/db/df0e99d6c5fe19ee5c981d22aad557be4bdeed3ecfae25d47b84b07f0f98/Cython-0.29.36.tar.gz"
  sha256 "41c0cfd2d754e383c9eeb95effc9aa4ab847d0c9747077ddd7c0dcb68c3bc01f"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae0e52e1ba4151900a0cf3a541dbcfad6df51c15e3b0049c70f8afea1e438180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba2c0d72ab718333312df83ff0cbdc923018c5e7ef7408dd2d7fef03abaf76bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edcb8731e4125212de9aeef5426a93b13c5da5750527be114fbde836154e3c22"
    sha256 cellar: :any_skip_relocation, ventura:        "e87392634668a99ee4601861fc430f35aedf022a436153e8aab33a11f5aa1aac"
    sha256 cellar: :any_skip_relocation, monterey:       "637374e47099bb02ff920324b893bac93be2402cbec0cb1ab788978cbe10d481"
    sha256 cellar: :any_skip_relocation, big_sur:        "64c97b24af010a12e0a52ea6792cac4d60e667cdb25f6f29f5b00a81e19393b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9141cdd2af929f1ad8f800f75bf5491d4d3761cca64bf4d103cbf0130d890202"
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
