{ nixpkgs ? <nixpkgs>
, nixpkgsArgs ? { config.allowUnfree = true; }
, project ? <project>
}:
let
  pkgs = import nixpkgs nixpkgsArgs;
in {
  build = pkgs.callPackage ./. {
    # filterSource (used by buildMaven) doesn't like string contexts. This seems
    # like a bug, but we can work around it.
    project = builtins.unsafeDiscardStringContext project;
  };
}
