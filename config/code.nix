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
    agentPackages.opencode
    agentPackages.opencode2
    codexCli
    gcc
    gh
    grim
    nixd
    opencode-desktop
    ripgrep
    rstudio
    stablePkgs.jetbrains.clion
    t3code
    wf-recorder
  ];

  nix.settings = {
    extra-substituters = [ "https://codex-cli.cachix.org" ];
    extra-trusted-public-keys = [
      "codex-cli.cachix.org-1:1Br3H1hHoRYG22n//cGKJOk3cQXgYobUel6O8DgSing="
    ];
  };

  home-manager.users.jafed = {
    imports = [ inputs.codex.homeManagerModules.default ];

    programs.codexDesktopLinux = {
      enable = false;
      cliPackage = codexCli;
      computerUseUi.enable = true;
      remoteMobileControl.enable = true;
      remoteControl.enable = true;
    };
  };
}
