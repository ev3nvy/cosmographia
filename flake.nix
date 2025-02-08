{
  # cosmographia segfaults on startup if only nixpkgs-qt4 is used
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs-qt4.url = "github:nixos/nixpkgs/a63a64b593dcf2fe05f7c5d666eb395950f36bc9";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-qt4,
  }: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
        pkgs-qt4 = import nixpkgs-qt4 {inherit system;};
      in {
        default = pkgs.callPackage ./nix/build.nix {inherit (pkgs-qt4) qmake4Hook qt4;};
      }
    );
    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = pkgs.mkShell {
          inputsFrom = [self.packages.${system}.default];
        };
        full = pkgs.mkShell {
          inputsFrom = with self.devShells.${system}; [default];
          packages = [self.packages.${system}.default];
        };
      }
    );
  };
}
