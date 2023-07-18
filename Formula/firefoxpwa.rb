class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "f19bef914a48d936fc4aab01757108e3bd6bc93e10e54f60844df630fbfe7ef1"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "881931bc3a19b9e215e54f35786156f762f8c879a603f14a8b51380f42e5fb33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4518c731386656517a75bc91c417322126793caa7257166674e4bec6e3e257e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcfc793d57005bb87ae563a31d35fc7d863736162133d5ccb22971bd1fa1d1c9"
    sha256 cellar: :any_skip_relocation, ventura:        "befd5f4336c74ed0ec6cc936756b3999028d69afa09e5cf8903831b8b7e2a1cf"
    sha256 cellar: :any_skip_relocation, monterey:       "5d5b185aaeb5120c1ff11e014085faa8ba09facf8a38ff47730f00a2c1c7e805"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e0b4601f9d389f7a99dc39302b42c46e9ad556a7a5ced807c7a5e07531a3de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e51ff63e53b25d2d1681db709cad50f27fdd6167a64f8b92408ca7d779f7287c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "bzip2" # not used on macOS
    depends_on "openssl@3"
  end

  def install
    cd "native"

    # Prepare the project to work with Homebrew
    ENV["FFPWA_EXECUTABLES"] = opt_bin
    ENV["FFPWA_SYSDATA"] = opt_share
    system "bash", "./packages/brew/configure.sh", version, opt_bin, opt_libexec

    # Build and install the project
    system "cargo", "install", *std_cargo_args

    # Install all files
    libexec.install bin/"firefoxpwa-connector"
    share.install "manifests/brew.json" => "firefoxpwa.json"
    share.install "userchrome/"
    bash_completion.install "target/release/completions/firefoxpwa.bash" => "firefoxpwa"
    fish_completion.install "target/release/completions/firefoxpwa.fish"
    zsh_completion.install "target/release/completions/_firefoxpwa"
  end

  def caveats
    filename = "firefoxpwa.json"

    source = opt_share
    destination = "/Library/Application Support/Mozilla/NativeMessagingHosts"

    on_linux do
      destination = "/usr/lib/mozilla/native-messaging-hosts"
    end

    <<~EOS
      To use the browser extension, manually link the app manifest with:
        sudo mkdir -p "#{destination}"
        sudo ln -sf "#{source}/#{filename}" "#{destination}/#{filename}"
    EOS
  end

  test do
    # Test version so we know if Homebrew configure script correctly sets it
    assert_match "firefoxpwa #{version}", shell_output("#{bin}/firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}/firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end
