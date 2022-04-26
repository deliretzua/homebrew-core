class ErlangAT23 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.13/otp_src_23.3.4.13.tar.gz"
  sha256 "f9085856fa5c1d6b8c5385cab2fd750068206213de8cb5642ba5b3023c752fc8"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(23(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1c16bbc491ca9d8cdeb00e3d607da3fb7337bce6c347fc1c2a73fdd1de1ad634"
    sha256 cellar: :any,                 arm64_big_sur:  "65a18355fee7e44f6a755b5cf79b27f839c66daf407a435451971a62151bc930"
    sha256 cellar: :any,                 monterey:       "a0d0535f5bed8f0ee7e7cba08d3c5cf97e23cdb8189af516023a203a6de4535a"
    sha256 cellar: :any,                 big_sur:        "229c5c3fdfa0b55022515cfff2d51f5764a37f4b8eb07a261b6ac9c0706d53bc"
    sha256 cellar: :any,                 catalina:       "3b2ccadc95fe8ad66dbe4c012bb541e83ec5494656ddb829644c31cfe2df4ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c121a2c1ecca5dcd91cf376db5a8e0c901d25173118650002461bfa0b4047498"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.13/otp_doc_html_23.3.4.13.tar.gz"
    sha256 "37e2aeee06def0921aa35f4b306a42984328928caaf881171e076e95b6c8a57c"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Build the doc chunks (manpages are also built by default)
    system "make", "docs", "DOC_TARGETS=chunks"
    system "make", "install-docs"

    doc.install resource("html")
  end

  def caveats
    <<~EOS
      Man pages can be found in:
        #{opt_lib}/erlang/man

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
    (testpath/"factorial").write <<~EOS
      #!#{bin}/escript
      %% -*- erlang -*-
      %%! -smp enable -sname factorial -mnesia debug verbose
      main([String]) ->
          try
              N = list_to_integer(String),
              F = fac(N),
              io:format("factorial ~w = ~w\n", [N,F])
          catch
              _:_ ->
                  usage()
          end;
      main(_) ->
          usage().

      usage() ->
          io:format("usage: factorial integer\n").

      fac(0) -> 1;
      fac(N) -> N * fac(N-1).
    EOS
    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output("./factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output("./factorial 42")
  end
end
