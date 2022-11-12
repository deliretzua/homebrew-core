class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/7d/61/e3cfc5e1cb8f711a6da0fe813a01c01b793c594a401c3c579fc0a0e41027/liquidctl-1.11.1.tar.gz"
  sha256 "278c1aca8d891bfe8e0c164dfe6651261a0423b29f9c24cef060c3613f2a4fd7"
  license "GPL-3.0-or-later"
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae2b3ebcd0d43381d537f727beb434bc635371ee9173ddb6f5460eadc1472409"
    sha256 cellar: :any,                 arm64_monterey: "9f557275ce3a5705cb47fd1672cdc09904e8749a0b3842cf2741081de19764ce"
    sha256 cellar: :any,                 arm64_big_sur:  "181b800262374b7ea10e43e3bfca29522a1b55c027658748058f92d8ac0e1198"
    sha256 cellar: :any,                 monterey:       "3a41b8a0ef4876c9efc8196937af8fdaa4438286dae48b942ccff3388b6dc51c"
    sha256 cellar: :any,                 big_sur:        "180b26d0cec656436028e2bea88fe83f68807b9f98d3aaf6b88ab9d99cb5a6ce"
    sha256 cellar: :any,                 catalina:       "6c9f63f79ab41e330e660c4486e356acd9f320a21122f378c99d1049e2baf40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bc07083bb42ca79801b57590094d53d7b18dc23d19c82c692b7074b10338b88"
  end

  depends_on "hidapi"
  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.10"

  on_linux do
    depends_on "i2c-tools"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/ef/72/54273f701c737ae5f42d9c0adf641912d20eb955c75433f1093fa509bcc7/hidapi-0.12.0.post2.tar.gz"
    sha256 "8ebb2117be8b27af5c780936030148e1971b6b7fda06e0581ff0bfb15e94ed76"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/d9/6e/433a5614132576289b8643fe598dd5d51b16e130fd591564be952e15bb45/pyusb-1.2.1.tar.gz"
    sha256 "a4cc7404a203144754164b8b40994e2849fde1cfff06b08492f12fff9d9de7b9"
  end

  def install
    # customize liquidctl --version
    ENV["DIST_NAME"] = "homebrew"
    ENV["DIST_PACKAGE"] = "liquidctl #{version}"

    python3 = "python3.10"
    venv = virtualenv_create(libexec, python3)

    resource("hidapi").stage do
      inreplace "setup.py" do |s|
        s.gsub! "/usr/include/libusb-1.0", "#{Formula["libusb"].opt_include}/libusb-1.0"
        s.gsub! "/usr/include/hidapi", "#{Formula["hidapi"].opt_include}/hidapi"
      end
      system python3, *Language::Python.setup_install_args(libexec, python3), "--with-system-hidapi"
    end

    venv.pip_install resources.reject { |r| r.name == "hidapi" }
    venv.pip_install_and_link buildpath

    man_page = buildpath/"liquidctl.8"
    # setting the is_macos register to 1 adjusts the man page for macOS
    inreplace man_page, ".nr is_macos 0", ".nr is_macos 1" if OS.mac?
    man.mkpath
    man8.install man_page

    (lib/"udev/rules.d").install Dir["extra/linux/*.rules"] if OS.linux?
  end

  test do
    shell_output "#{bin}/liquidctl list --verbose --debug"
  end
end
