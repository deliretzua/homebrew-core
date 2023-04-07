class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.21.0/nifi-registry-1.21.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.21.0/nifi-registry-1.21.0-bin.zip"
  sha256 "4c0b0f9424b78bf7031404a2727e6e533f50a1b53beae1c407aa98a53aef328f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95803ac768210c3df9526da19851ed4e4158d217533818318808e13dec18ec2a"
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
