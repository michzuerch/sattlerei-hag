{
  description = "Blog Playwright michzuerch.github.io";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";

    devToolkit = {
      url = "github:primamateria/dev-toolkit-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, utils, devToolkit, haumea, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        src = haumea.lib.load {
          src = ./.nix;
          inputs = { inherit pkgs; };
        };
      in {
        devShell = devToolkit.lib.${system}.buildDevShell {
          name = "michzuerch webdev";
          profiles = [ "node" ];
          extraPackages = [ src.playwright-browsers-1_46_1 ];
          extraShellHook = ''
            # Prepare playwright
            export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
            export PLAYWRIGHT_BROWSERS_PATH=${src.playwright-browsers-1_46_1}
            export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
          '';
        };
      });

}
