{ nixpkgs ? <nixpkgs>
, nixpkgsArgs ? { config.allowUnfree = true; }
, project ? <project>
}:
let
  pkgs = import nixpkgs nixpkgsArgs;
in {
  build = pkgs.callPackage ./. { inherit project; };
}
