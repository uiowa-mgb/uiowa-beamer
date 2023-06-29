{
  description = "A beamer theme for uiowa";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # This technically pulls in more stuff than necessary to build
    tex = pkgs.texlive.combine {
      inherit
        (pkgs.texlive)
        scheme-basic # A good minimal base for latex
        beamer # Latex presentations
        biber # Our bibiolgraphy backend
        biblatex # Generating the bibliography more better
        latexmk # For actually compiling latex
        textpos
        xcolor
        xetex # The actual tex engine to use
        ;
    };
  in {
    formatter.${system} = pkgs.alejandra;

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        tex
        pkgs.scons
        pkgs.glow # make help text prettier
        pkgs.inotify-tools # watches for changes
        pkgs.zip
        pkgs.gnumake
      ];

      shellHook = ''
        clear
        (
          echo "Welcome to a dev-shell!"
          echo "Run \`make help\` to see all available targets"
        ) | glow
      '';
    };
  };
}
