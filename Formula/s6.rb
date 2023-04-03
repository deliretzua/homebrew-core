class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.11.3.2.tar.gz"
  sha256 "7c16138ad2f0ffbe0ed2ae8dd0cecada9f7c787edd33a69084d219110693df74"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c82ea3b1c591f6aaa077f84962ee7c1c224dad5e382ac8d5162c1befd936d8fb"
    sha256 arm64_monterey: "e94af0b2a1119143b2d76f094f6e444ab7f19f12963d554573a9397fa508eee0"
    sha256 arm64_big_sur:  "5b42da2e8f1bc145f5cddcc5f5daf7a8078e3d2f77991da30a70ee60ec48265a"
    sha256 ventura:        "c1085920c308c32680e12d0fafd5d0f79d9117276d5fb7dd722ac8124de57953"
    sha256 monterey:       "5de223f19bd661602e0a77bf51688b1800716d32b6baf1e388da4a1d55ce0d58"
    sha256 big_sur:        "e4e412e0fb5001c580794a58bf8c0ad5d0236c73d7555a0f5b7aae61942cc231"
    sha256 x86_64_linux:   "4891d27cf93044135193523ef758834f1b2caac14de80cb6f72593db59d0626f"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.13.1.1.tar.gz"
    sha256 "b272a1ab799f7fac44b9b4fb5ace78a9616b2fe4882159754b8088c4d8199e33"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.3.0.tar.gz"
    sha256 "c8027fa70922d117cdee8cc20d277e38d03fd960e6d136d8cec32603d4ec238d"
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }
    build_dir = buildpath/"build"

    cd "skalibs" do
      system "./configure", "--disable-shared", "--prefix=#{build_dir}", "--libdir=#{build_dir}/lib"
      system "make", "install"
    end

    cd "execline" do
      system "./configure",
        "--prefix=#{build_dir}",
        "--bindir=#{libexec}/execline",
        "--with-include=#{build_dir}/include",
        "--with-lib=#{build_dir}/lib",
        "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
        "--disable-shared"
      system "make", "install"
    end

    system "./configure",
      "--prefix=#{prefix}",
      "--libdir=#{build_dir}/lib",
      "--includedir=#{build_dir}/include",
      "--with-include=#{build_dir}/include",
      "--with-lib=#{build_dir}/lib",
      "--with-lib=#{build_dir}/lib/execline",
      "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
      "--disable-static",
      "--disable-shared"
    system "make", "install"

    # Some S6 tools expect execline binaries to be on the path
    bin.env_script_all_files(libexec/"bin", PATH: "#{libexec}/execline:$PATH")
    sbin.env_script_all_files(libexec/"sbin", PATH: "#{libexec}/execline:$PATH")
    (bin/"execlineb").write_env_script libexec/"execline/execlineb", PATH: "#{libexec}/execline:$PATH"
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")

    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
