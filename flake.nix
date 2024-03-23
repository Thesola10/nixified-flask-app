{ description = "Template for a flask app with builtin prod-ready NixOS module";

  inputs."nixpkgs".url = github:NixOS/nixpkgs;

  outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let pkgs = import nixpkgs { inherit system; };
    in
    { packages.default = pkgs.callPackage ./default.nix {};
      devShells.default = pkgs.mkShell {
        inputsFrom = [ self.packages.${system}.default ];
        buildInputs = with pkgs.python3Packages; [
          venvShellHook
        ];

        venvDir = ".venv";
      };
    })
  // { nixosModules.default = import ./nixos; };
}
