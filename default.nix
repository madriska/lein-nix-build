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

  LEIN_OFFLINE = 1;

  configurePhase = ''
    mkdir -p home/.m2
    ln -s ${repo} home/.m2/repository
    # This is so hacky!
    cat > java <<EOF
    exec ${jdk}/bin/java -Duser.home=$PWD/home "\$@"
    EOF
    chmod +x java
    export LEIN_JAVA_CMD=$PWD/java
  '';

  buildPhase = "HOME=$PWD/home lein uberjar";

  installPhase = ''
    find . -name '*standalone.jar' -exec mv '{}' $out \;
  '';
}
