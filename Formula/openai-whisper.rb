class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/00/c6/fb251c4f7de1c78753a2d54d6aaf1a859ddc3797ed4d6003f15866f4c4a4/openai-whisper-20230124.tar.gz"
  sha256 "31adf9353bf0e3f891b6618896f22c65cf78cd6f845a4d5b7125aa5102187f79"
  license "MIT"
  head "https://github.com/openai/whisper.git", branch: "main"

  depends_on "rust" => :build # for tokenizers
  depends_on "ffmpeg"
  depends_on "huggingface-cli"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "pytorch"
  depends_on "pyyaml"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "ffmpeg-python" do
    url "https://files.pythonhosted.org/packages/dd/5e/d5f9105d59c1325759d838af4e973695081fbbc97182baf73afc78dec266/ffmpeg-python-0.2.0.tar.gz"
    sha256 "65225db34627c578ef0e11c8b1eb528bb35e024752f6f10b78c011f6f64c4127"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/13/b3/397aa9668da8b1f0c307bc474608653d46122ae0563d1d32f60e24fa0cbd/more-itertools-9.0.0.tar.gz"
    sha256 "5a6257e40878ef0520b1803990e3e22303a41b5714006c32a3fd8304b26ea1ab"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/4a/d9/af2821b5934ed871f716eb65fb3bd43e7bc70b99191ec08f20cfd642d0a1/tokenizers-0.13.2.tar.gz"
    sha256 "f9525375582fd1912ac3caa2f727d36c86ff8c0c6de45ae1aaff90f87f33b907"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/51/3c/d74d92cf18df4d9c6c261e1c85f9db447ed55d4c3bb88c6c04c626238120/transformers-4.26.1.tar.gz"
    sha256 "32dc474157367f8e551f470af0136a1ddafc9e18476400c3869f1ef4f0c12042"
  end

  resource "test-audio" do
    url "https://raw.githubusercontent.com/openai/whisper/7858aa9c08d98f75575035ecd6481f462d66ca27/tests/jfk.flac"
    sha256 "63a4b1e4c1dc655ac70961ffbf518acd249df237e5a0152faae9a4a836949715"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "test-audio" }
    venv.pip_install_and_link buildpath

    # link the `huggingface-cli` virtualenv to this one
    site_packages = Language::Python.site_packages(python3)
    package = Formula["huggingface-cli"].opt_libexec
    (libexec/site_packages/"homebrew-huggingface-cli.pth").write package/site_packages
  end

  test do
    testpath.install resource("test-audio")
    # for some unknown reason, the file is installed as `tests` rather than `jfk.flac`
    system "#{bin}/whisper", "tests", "--model", "tiny.en", "--output_format", "txt"
    transcription = File.read("tests.txt")
    assert_equal transcription, <<~EOS
      And so, my fellow Americans ask not what your country can do for you
      ask what you can do for your country.
    EOS
  end
end
