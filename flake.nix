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
      buildInputs = [ pkgs.cargo ];
      shellHook = 
        ''
        mkdir ./cargo
        export PATH=$PATH:./cargo/bin
        cargo install hvm --root ./cargo 
        cargo install bend-lang --root ./cargo --git https://github.com/HigherOrderCO/Bend.git --tag 0.2.37-alpha.1
        '';
      
    };
  };
}
