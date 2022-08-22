class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/containers/podman/archive/v4.2.0.tar.gz"
    sha256 "15f8bc59025ccd97dc9212a552e7274dfb79e1633b02d6a2a7f63d747eadb2f4"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.4.0.tar.gz"
      sha256 "896cf02fbabce9583a1bba21e2b384015c0104d634a73a16d2f44552cf84d972"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "6466fc5a3b84b64a3a58e87521b0997ab5bfe9be43c8fc11a18ed0013376c34a"
    sha256 arm64_big_sur:  "33f9e47f8fda7d3ca59a196a631ddded0fcaebb39fde9852de552a52bb14b488"
    sha256 monterey:       "1376281fdd170f4b541bee26fad113c640b2490a4b6a0e9120bd03f53884f0a5"
    sha256 big_sur:        "835e0c5e55d9e9b38047c6a1e3701925ff99e8de049dcef25412c1f07a9836a7"
    sha256 catalina:       "a62e385fda0f97e4214a2ea50d253837a730db14566d202c24b1fead662188fa"
    sha256 x86_64_linux:   "9f62f0cb05daf1085eb9c78dbf1f01c0a28c0b15d1b7f4cdebd49313bcef46b5"
  end

  # The path to libexec where `gvproxy` can be found is hardcoded into the Go binary.
  # Therefore, only use pre-built bottle if installing in default prefix.
  # Otherwise, rebuild from source.
  pour_bottle? only_if: :default_prefix

  head do
    url "https://github.com/containers/podman.git", branch: "main"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock.git", branch: "main"
    end
  end

  depends_on "go-md2man" => :build
  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build
  depends_on "qemu"

  def install
    ENV["CGO_ENABLED"] = "1"
    os = OS.kernel_name.downcase

    ENV["HELPER_BINARIES_DIR"] = libexec
    system "make", "podman-remote"
    if OS.mac?
      bin.install "bin/#{os}/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"
      system "make", "podman-mac-helper"
      bin.install "bin/#{os}/podman-mac-helper" => "podman-mac-helper"
    else
      bin.install "bin/podman-remote"
    end

    resource("gvproxy").stage do
      system "make", "gvproxy"
      libexec.install "bin/gvproxy"
    end

    system "make", "podman-remote-#{os}-docs"
    man1.install Dir["docs/build/remote/#{os}/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
    fish_completion.install "completions/fish/podman.fish"
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}/podman-remote -v")
    assert_match(/Cannot connect to Podman/i, shell_output("#{bin}/podman-remote info 2>&1", 125))

    machineinit_output = shell_output("podman-remote machine init --image-path fake-testi123 fake-testvm 2>&1", 125)
    assert_match "Error: open fake-testi123: no such file or directory", machineinit_output
  end
end
