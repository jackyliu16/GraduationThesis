{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    latex-utils = {
      # url = "github:jackyliu16/latex-utils";
      url = "git+file:///home/jacky/Documents/latex-utils/";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    latex-utils,
  }:
    with flake-utils.lib; eachSystem allSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      texPackages = {
        # NOTE: add some latex package you want 
        inherit (pkgs.texlive) xecjk xetex;
      };
    in {
      packages.default = latex-utils.lib.${system}.mkLatexPdfDocument {
        name = "mydocument";
        src = self;
        inherit texPackages;
        inputFile = "main.tex";

        fonts = [
          "${./fonts}"
        ];

        # TODO:  impure
        buildPhase = ''
          xelatex main.tex 
          xelatex main.tex 
        '';
        installPhase = ''
          mv main.pdf $out 
        '';
      };
    });
}
