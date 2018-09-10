/*opam-version: "2.0"
  name: "ppx_optcomp"
  version: "v0.10.0"
  synopsis: "Optional compilation for OCaml"
  description: "Part of the Jane Street's PPX rewriters
  collection."
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_optcomp"
  bug-reports: "https://github.com/janestreet/ppx_optcomp/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "ppx_core" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_optcomp.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_optcomp-v0.10.0.tar.gz"
    checksum: "md5=2e86bd2e41407cb16dcd1a546e43e531"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ppx_core, jbuilder, findlib
  }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.04.1";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_core) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_core) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta12";

stdenv.mkDerivation rec {
  pname = "ppx_optcomp";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_optcomp-v0.10.0.tar.gz";
    sha256 = "01nyw4kkvvxi5i3r93n9dmj2rczqjcy7fjr6mp2rq365z0rwnz18";
  };
  buildInputs = [
    ocaml ppx_core jbuilder findlib ];
  propagatedBuildInputs = [
    ocaml ppx_core jbuilder ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
