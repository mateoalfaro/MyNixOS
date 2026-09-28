{
  inputs,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  # Vicre now runs the Gemini agent CLI (agy, antigravity-cli) via the
  # opaque vicre.package; no model pinning needed here — the default
  # gemini-3.7-flash-high is fine.
  programs.vicre = {
    enable = true;
    user = "jafed";
    package = inputs.vicre.packages.x86_64-linux.vicre;
    model = "opencode-go/muse-spark-1.3-contributor";
    variant = "xhigh";
  };
}
