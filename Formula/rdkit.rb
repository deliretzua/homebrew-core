class Rdkit < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://rdkit.org/"
  url "https://github.com/rdkit/rdkit/archive/Release_2020_09_4.tar.gz"
  sha256 "9e734ca8f99d8be1ef2ac51efb67c393c62e88b98cfa550d6173ce3eaa87b559"
  license "BSD-3-Clause"
  head "https://github.com/rdkit/rdkit.git"

  bottle do
    sha256 arm64_big_sur: "049c8a2845019025f26effd08e0b2565054d67380d8d1eca17402a3b54e30486"
    sha256 big_sur:       "92ac239f24a9dc64b46272f0c37cad922a8f87adaf5b6b63c24b660158b39ab2"
    sha256 catalina:      "bc789aede5a44347bf9e83ff98f7097fa1c8713834a0b0d29f4ea5d0bfccf2b5"
    sha256 mojave:        "23078b78af79a9b369746b759803691adeeb88a402f3d3dd7d635653fd07da2f"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "postgresql"
  depends_on "py3cairo"
  depends_on "python@3.9"

  def install
    ENV.cxx11
    ENV.libcxx
    ENV.append "CFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"
    ENV.append "CXXFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"

    # Get Python location
    python_executable = Formula["python@3.9"].opt_bin/"python3"
    py3ver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py3prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{py3ver}"
    py3include = "#{py3prefix}/include/python#{py3ver}"

    # set -DMAEPARSER and COORDGEN_FORCE_BUILD=ON to avoid conflicts with some formulae i.e. open-babel
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
      -DRDK_INSTALL_INTREE=OFF
      -DRDK_BUILD_SWIG_WRAPPERS=OFF
      -DRDK_BUILD_AVALON_SUPPORT=ON
      -DRDK_BUILD_PGSQL=ON
      -DRDK_PGSQL_STATIC=ON
      -DMAEPARSER_FORCE_BUILD=ON
      -DCOORDGEN_FORCE_BUILD=ON
      -DRDK_BUILD_INCHI_SUPPORT=ON
      -DRDK_BUILD_CPP_TESTS=OFF
      -DRDK_INSTALL_STATIC_LIBS=OFF
      -DRDK_BUILD_CAIRO_SUPPORT=ON
      -DRDK_BUILD_YAEHMOP_SUPPORT=ON
      -DRDK_BUILD_FREESASA_SUPPORT=ON
      -DBoost_NO_BOOST_CMAKE=ON
      -DPYTHON_INCLUDE_DIR=#{py3include}
      -DPYTHON_EXECUTABLE=#{python_executable}
    ]

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You may need to add RDBASE to your environment variables.
      For Bash, put something like this in your $HOME/.bashrc:
        export RDBASE=#{HOMEBREW_PREFIX}/share/RDKit
    EOS
  end

  test do
    (testpath/"test.py").write <<~EOS
      from rdkit import Chem ; print(Chem.MolToSmiles(Chem.MolFromSmiles('C1=CC=CN=C1')))
    EOS
    assert_match "c1ccncc1", shell_output("#{Formula["python@3.9"].opt_bin}/python3 test.py 2>&1")
  end
end
