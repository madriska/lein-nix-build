get-dependency: let
  pkgs = import (get-dependency "nixpkgs") {};
in project: pkgs.callPackage ./. {
  inherit project;
}
