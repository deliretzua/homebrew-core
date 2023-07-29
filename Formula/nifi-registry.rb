class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.23.0/nifi-registry-1.23.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.23.0/nifi-registry-1.23.0-bin.zip"
  sha256 "978b7fe75c6207a8272b1d43b6ce1b44091158bc5169bf64d864df2d94db120b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9eed0188d4038b23612435c3bf2059aa3429e0a014d6fec34e2ccd98efd344f9"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    rm Dir[libexec/"bin/*.bat"]

    bin.install libexec/"bin/nifi-registry.sh" => "nifi-registry"
    bin.env_script_all_files libexec/"bin/",
                             Language::Java.overridable_java_home_env.merge(NIFI_REGISTRY_HOME: libexec)
  end

  test do
    output = shell_output("#{bin}/nifi-registry status")
    assert_match "Apache NiFi Registry is not running", output
  end
end
