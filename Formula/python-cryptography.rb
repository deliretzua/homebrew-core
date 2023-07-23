class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/93/b7/b6b3420a2f027c1067f712eb3aea8653f8ca7490f183f9917879c447139b/cryptography-41.0.2.tar.gz"
  sha256 "7d230bf856164de164ecb615ccc14c7fc6de6906ddd5b491f3af90d3514c925c"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/0e/c9/6f9de9f7a8404416d5d22484ccdeb138f469cc1e11bbd62a2bd26d5c1385/setuptools-rust-1.6.0.tar.gz"
    sha256 "c86e734deac330597998bfbc08da45187e6b27837e23bd91eadb320732392262"
  end

  def python3
    "python3.11"
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    ENV.append_path "PYTHONPATH", site_packages

    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", "--prefix=#{prefix}", "--no-deps", "--no-build-isolation", "."
      end
    end

    system python3, "-m", "pip", "install", "--prefix=#{prefix}", "--no-deps", "--no-build-isolation", "."
  end

  test do
    (testpath/"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    assert_match "b'homebrew'", shell_output("#{python3} test.py")
  end
end
