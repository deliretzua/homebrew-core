class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.27.1.tar.gz"
  sha256 "508b6612ca30ef4404aa674a2fb2a93e414eb5b06afe34e090145e70f0dc940a"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05badb3bfa6b9e1d6536971766570f20c75d992184ba11820afc6d7f5a00cee8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05badb3bfa6b9e1d6536971766570f20c75d992184ba11820afc6d7f5a00cee8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05badb3bfa6b9e1d6536971766570f20c75d992184ba11820afc6d7f5a00cee8"
    sha256 cellar: :any_skip_relocation, ventura:        "8b1c1fa89a2cd1089dcc6b0891303dba88a8d3d02d3016007409242cf20bfb84"
    sha256 cellar: :any_skip_relocation, monterey:       "8b1c1fa89a2cd1089dcc6b0891303dba88a8d3d02d3016007409242cf20bfb84"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b1c1fa89a2cd1089dcc6b0891303dba88a8d3d02d3016007409242cf20bfb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f91a5cb013b5dcde46dd9ce2de1a17cec1bd4402f75d5476230e104138d69018"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    str_version = shell_output("#{bin}/task --version")
    assert_match "Task version: #{version}", str_version

    taskfile = testpath/"Taskfile.yml"
    taskfile.write <<~EOS
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    EOS

    args = %W[
      --taskfile #{taskfile}
      --silent
    ].join(" ")

    ok_test = shell_output("#{bin}/task #{args} test")
    assert_match "Testing Taskfile", ok_test
  end
end
