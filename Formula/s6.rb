class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.11.0.1.tar.gz"
  sha256 "ad7f204587634eeb20ef8f7a7beb6dd63ba3080a46a3a650448ca7cc0826f90a"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "13615918f388b38eeef30dea23dad86323e05a9d8abd530adc9a2f87a5820fd6"
    sha256 arm64_big_sur:  "b9da08275302eeb6457ba5bf2dff2ce96659bdbdc1105f7477e2dbf96ef9d22f"
    sha256 monterey:       "b94e04c86c6977b9387269d9e01d71ca58f77c2ab594a019fd53dc45305ea657"
    sha256 big_sur:        "24d615356898f31742e83bc79e1441802a845f511bc9a4a127e6f496c676eaaf"
    sha256 catalina:       "d59a7a1fc6bac32484b4bd3771f2dd230da609acdc6402b54ed59bfb1a1f2e91"
    sha256 x86_64_linux:   "50d2f7b24c46b5c06f60433a6b89c0228646995338330b66ea3c707a037d34fa"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.11.1.0.tar.gz"
    sha256 "400180b4d5b651e4fafaf0297b933f5f863b467d357f5b36a6545cf6eb14eab9"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.8.2.0.tar.gz"
    sha256 "2fdf7607f306e94fe42ebe2b49872d0f654aa2297a576d5a2d8037d4d9583341"
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
