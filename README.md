lein-nix-build
===============

nix expressions for building lein projects with mvn2nix.

Setup
------

1. Copy any `:plugins` defined in your `project.clj` to `:pom-plugins`.
2. If you use a custom wagon for downloading dependencies, add the corresponding
   maven extension to `:extensions` in your `project.clj`. For example, if you
   use `lein-maven-s3-wagon`, you can add `maven-s3-wagon` to `:extensions`.
3. Run `lein pom`
4. Run `mvn org.nixos.mvn2nix:mvn2nix-maven-plugin:mvn2nix`

Steps 3 and 4 must be performed whenever any dependencies change.

Building locally
-----------------

`nix-build -I project=/path/to/lein/project`

Building on hydra
------------------

Use the `release.nix` in this repository as the nix expression for evaluation.
Set the `project` input to a checkout of the project you want to build.
