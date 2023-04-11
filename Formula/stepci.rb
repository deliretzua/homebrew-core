require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.6.6.tgz"
  sha256 "d79e65355f31170452278fd9863033baf66128a33f7523371a6aa1baf2554bab"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f693e708680d4be13b3c370939ccfc5bc68055c180a5d6d5aaa2adc4e1aed177"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f693e708680d4be13b3c370939ccfc5bc68055c180a5d6d5aaa2adc4e1aed177"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f693e708680d4be13b3c370939ccfc5bc68055c180a5d6d5aaa2adc4e1aed177"
    sha256 cellar: :any_skip_relocation, ventura:        "1e0266ea0443c977eeaaafaccc28cad6f5976460308bb3fadcdb44e6b5425ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "1e0266ea0443c977eeaaafaccc28cad6f5976460308bb3fadcdb44e6b5425ccb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e0266ea0443c977eeaaafaccc28cad6f5976460308bb3fadcdb44e6b5425ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f693e708680d4be13b3c370939ccfc5bc68055c180a5d6d5aaa2adc4e1aed177"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://docs.stepci.com/legal/privacy.html
    ENV["STEPCI_DISABLE_ANALYTICS"] = "1"

    (testpath/"workflow.yml").write <<~EOS
      version: "1.1"
      name: Status Check
      env:
        host: example.com
      tests:
        example:
          steps:
            - name: GET request
              http:
                url: https://${{env.host}}
                method: GET
                check:
                  status: /^20/
    EOS

    expected = <<~EOS
      Tests: 0 failed, 1 passed, 1 total
      Steps: 0 failed, 0 skipped, 1 passed, 1 total
    EOS
    assert_match expected, shell_output("#{bin}/stepci run workflow.yml")

    assert_match version.to_s, shell_output("#{bin}/stepci --version")
  end
end
