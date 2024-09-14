{
  description = "Development environment for Python";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      
      pkgs = import nixpkgs { 
        inherit system;
      };
    in
    {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [ pkgs.bend pkgs.cargo ];
      shellHook = 
        ''
        mkdir ./cargo
        export PATH=$PATH:./cargo/bin
        cargo install hvm --root ./cargo
        '';
      
    };
  };
}
