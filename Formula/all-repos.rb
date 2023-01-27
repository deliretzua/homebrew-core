class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/14/60/5f0d6f6193629929299422fbb87711983a764aa53820caf9ede7b0f4d389/all_repos-1.24.0.tar.gz"
  sha256 "a4e3dfdd8adebdbffbb659b06a516f6fa0967247cee87356911860e1302292df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8f82f391364d358f0e9f5d72dd24fde687e2044cc4d99a53f1815a201df93ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a1297852ba88d21c945a8a6805d275108ef3c687b6558552bf08efdf87c3ca7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e0d1e4342fbc434d4621410732947d1a17bc000c974c18c340c3a368ef69f3e"
    sha256 cellar: :any_skip_relocation, ventura:        "879a9deda5ee9b9f1712ab348e34e82732daaf24c6fd94775f34cb49ae5b5b55"
    sha256 cellar: :any_skip_relocation, monterey:       "f726b990234aba29ffbd3c3efe1209e9642e955a48459d80ef516568ddd4c934"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fd22b0ad63457bc006e15a0ec3bb6d540e26c3077e4b0f4763cd69eca00caf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfcf220c2b71e988d7bb3fbd8e488d584a74f581be906cde0578d641483b4420"
  end

  depends_on "python@3.11"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/82/a9/3cf658d585698e8f14b09011018f4f3fd9d56b0eecefb79de89ec5cb6a92/identify-2.5.15.tar.gz"
    sha256 "c22aa206f47cc40486ecf585d27ad5f40adbfc494a3fa41dc3ed0499a23b123f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"all-repos.json").write <<~EOS
      {
        "output_dir": "out",
        "source": "all_repos.source.json_file",
        "source_settings": {"filename": "repos.json"},
        "push": "all_repos.push.readonly",
        "push_settings": {}
      }
    EOS
    chmod 0600, "all-repos.json"
    (testpath/"repos.json").write <<~EOS
      {"discussions": "https://github.com/Homebrew/discussions"}
    EOS

    system "all-repos-clone"
    assert_predicate testpath/"out/discussions", :exist?
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "out/discussions:README.md", output
  end
end
