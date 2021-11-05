class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/containers/podman/archive/v3.4.1.tar.gz"
    sha256 "3fa70c499a4733524354518e839eefa3f14b630a519393418d082880535c1e33"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.2.0.tar.gz"
      sha256 "a54da74d6ad129a1c8fed3802ba8651cce37b123ee0e771b0d35889dae4751fc"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b86bffeca7ae414d3a97db43021bed86cadac22d1ad3b7bc24efc09983066472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0b683729b4567a5b610c1feddbe2c30b958c3729ec4d4185fb73c6c7cfd2c91"
    sha256 cellar: :any_skip_relocation, monterey:       "21ba5f3a140df5344431000efd5dfb941832be0bfa0b27612143f2d8982721f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f70e26a2975741a29c22161559dd176fec1d96b085a76d92ff73756a47be6cb2"
    sha256 cellar: :any_skip_relocation, catalina:       "a9a7c3f81a6cd794aec724a22c052680e923b88ddc57a746cc0c341fad6ea7d6"
  end

  head do
    url "https://github.com/containers/podman.git", branch: "main"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock.git", branch: "main"
    end
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "qemu"

  def install
    ENV["CGO_ENABLED"] = "1"
    os = OS.kernel_name.downcase

    system "make", "podman-remote-#{os}"
    if OS.mac?
      bin.install "bin/#{os}/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"
    else
      bin.install "bin/podman-remote"
    end

    resource("gvproxy").stage do
      system "make", "gvproxy"
      libexec.install "bin/gvproxy"
    end

    if build.head?
      system "make", "podman-remote-#{os}-docs"
    else
      system "make", "install-podman-remote-#{os}-docs"
    end

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
