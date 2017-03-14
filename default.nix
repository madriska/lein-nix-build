let pkgs = import <nixpkgs> {}; in
{ buildMaven ? pkgs.buildMaven
, leiningen ? pkgs.leiningen
, jdk ? pkgs.jdk
, stdenv ? pkgs.stdenv
, project ? <project>
}:
let
  inherit (buildMaven (project + "/project-info.json")) repo build info;
in stdenv.mkDerivation {
  name = "${info.project.artifactId}-${info.project.version}-standalone.jar";

  inherit (build) src;

  buildInputs = [ leiningen ];

  nativeBuildInputs = [ pkgs.makeWrapper ];

  LEIN_OFFLINE = 1;

  configurePhase = ''
    mkdir -p home/.m2
    ln -s ${repo} home/.m2/repository
    ln -s ${jdk}/bin/java java
    wrapProgram java --add-flags -Duser.home=$PWD/home
    export LEIN_JAVA_CMD=$PWD/java
  '';

  buildPhase = "lein uberjar";

  installPhase = ''
    find . -name '*standalone.jar' -exec mv '{}' $out \;
  '';
}
