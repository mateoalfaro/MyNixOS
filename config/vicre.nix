{
  inputs,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  programs.vicre = {
    enable = true;
    user = "jafed";
    package = inputs.vicre.packages.${system}.vicre;

    model = "CrofAI/glm-5.3-flash";
    variant = "max";
  };
}
