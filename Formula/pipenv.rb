class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/be/65/79411d93b377cc1cf47da3e00ebdb4e5bfbeb49a4664f7587a1dd8265996/pipenv-2023.6.11.tar.gz"
  sha256 "223f8ba0a659974fe32cdc54b266800b799482c3adc64142e5ebb9d2fb8f0b3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e357e85cb000ed4c0d7375f627e29a88bd2ae00dfbe3d3f80443b6d86a3b6e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38c44d76e080d5b6c41db0479a2eefabc726c658789e5ef75aa77532b86d75fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac2bde857815bc5f032489b8f3619041e62cb5475e5e43cc93369c6a2f7ba387"
    sha256 cellar: :any_skip_relocation, ventura:        "0e4b08babb7e7ec6130e17719a9eac0c22f02b2e25b8c82964ce6a45c2d8c2a6"
    sha256 cellar: :any_skip_relocation, monterey:       "07287c38739bd1f41ea8a8afbffe576de3e73ad18e5dae43d0e1384d559ab786"
    sha256 cellar: :any_skip_relocation, big_sur:        "2680d07a530a3956ec24ef4bb41eb9ca1f2c8f4acc65b3b5312eaacb32ce9dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2528203cfe8b60be86205bc9be4977f13745c5fbeb718ebf9de20ebd010a18b5"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/31/73/5b47f2a0b8543c105f26f74e2a680ea74799379cf53802f0f979e9be9b7a/filelock-3.12.1.tar.gz"
    sha256 "82b1f7da46f0ae42abf1bc78e548667f484ac59d2bcec38c713cee7e2eb51e83"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d2/5d/29eed8861e07378ef46e956650615a9677f8f48df7911674f923236ced2b/platformdirs-3.5.3.tar.gz"
    sha256 "e48fabd87db8f3a7df7150a4a5ea22c546ee8bc39bc2473244730d4b56d2cc4e"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d6/37/3ff25b2ad0d51cfd752dc68ee0ad4387f058a5ceba4d89b47ac478de3f59/virtualenv-20.23.0.tar.gz"
    sha256 "a85caa554ced0c0afbd0d638e7e2d7b5f92d23478d05d17a76daeac8f279f924"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def python3
    "python3.11"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pip", libexec/"bin/virtualenv"
    (bin/"pipenv").write_env_script libexec/"bin/pipenv", PATH: "#{libexec}/tools:${PATH}"

    generate_completions_from_executable(libexec/"bin/pipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "--python", which(python3)
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
