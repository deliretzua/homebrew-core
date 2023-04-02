class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/0a/70/1500f05bddb16d795b29fac42954b3c8764c82367b8326c10f038471ae7f/Cython-0.29.34.tar.gz"
  sha256 "1909688f5d7b521a60c396d20bba9e47a1b2d2784bfb085401e1e1e7d29a29a8"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be0c691d6cd5a6d4fddb451f4ca631ff5db6eeb66c34125af92b575b4f66689c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d764c9f97a1a9e306af3da2f1487f1655349cea1552bd2abbf7fb2c353fcdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d95464d268e883e91cb65b07511cd4df4dc3a3223daafd16f8ece26ad7dff46"
    sha256 cellar: :any_skip_relocation, ventura:        "3cec41e6f556b916d01168c7c483825ab5e27ad24660d4610340879a62233975"
    sha256 cellar: :any_skip_relocation, monterey:       "6c4a2f6075f5cbfdcc8e4e467afd66f845cd03137155c085538e64e4ee9a23ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "32c0df922d0067357241e2d26f71a374d8e64dae909deb11cd7cfe040323c59d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec834f549c15e8330359e23b01a63f3240e5cd6ae607ad53d3f0005b2e504cfd"
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
