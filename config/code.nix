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
    opencode
    agentPackages.opencode2
    codexCli
    agentPackages.chatgpt
    agentPackages.dsh
    gcc
    gh
    grim
    nixd
    nil
    ripgrep
    rstudio
    stablePkgs.jetbrains.clion
    t3code
    nodejs
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
