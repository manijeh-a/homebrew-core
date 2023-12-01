class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.47.9/metabase.jar"
  sha256 "0a106531ab658d4f2242a83358fcf2c66179faa266e1780adee83b6727660a0f"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5086163ec7dea2fc270398cd272a399358d85333f95c8275e7b24a67d9c789c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5086163ec7dea2fc270398cd272a399358d85333f95c8275e7b24a67d9c789c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5086163ec7dea2fc270398cd272a399358d85333f95c8275e7b24a67d9c789c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5086163ec7dea2fc270398cd272a399358d85333f95c8275e7b24a67d9c789c7"
    sha256 cellar: :any_skip_relocation, ventura:        "5086163ec7dea2fc270398cd272a399358d85333f95c8275e7b24a67d9c789c7"
    sha256 cellar: :any_skip_relocation, monterey:       "5086163ec7dea2fc270398cd272a399358d85333f95c8275e7b24a67d9c789c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02bd28aeccef6522b6fbca842b9687d288ce2687d8202c6185afe3fec990550b"
  end

  head do
    url "https://github.com/metabase/metabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  service do
    run opt_bin/"metabase"
    keep_alive true
    require_root true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
