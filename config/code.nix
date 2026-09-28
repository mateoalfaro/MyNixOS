{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  agentPackages = inputs.llm-agents.packages.${system};
  codexCli = inputs.codex-cli.packages.${system}.default;
  stablePkgs = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    agentPackages.omp
    agentPackages.cli-proxy-api
    agentPackages.opencode2
    agentPackages.opencode2-desktop
    codexCli
    agentPackages.chatgpt
    agentPackages.claude-desktop
    gcc
    gh
    grim
    nixd
    nil
    ripgrep
    # rstudio removed: nixpkgs builds it against electron_41, which is EOL
    # and marked insecure (Refusing to evaluate package 'electron-41.10.6').
    jetbrains.clion
    t3code
    nodejs
    agentPackages.zcode
  ];

  nix.settings = {
    extra-substituters = [
      "https://codex-cli.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "codex-cli.cachix.org-1:1Br3H1hHoRYG22n//cGKJOk3cQXgYobUel6O8DgSing="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  home-manager.users.jafed = {
    imports = [ ];
  };
}
