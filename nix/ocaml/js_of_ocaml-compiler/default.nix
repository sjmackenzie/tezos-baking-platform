/*opam-version: "2.0"
  name: "js_of_ocaml-compiler"
  version: "3.1.0"
  synopsis: "Compiler from OCaml bytecode to Javascript"
  maintainer: "dev@ocsigen.org"
  authors: "Ocsigen team"
  homepage: "http://ocsigen.org/js_of_ocaml"
  bug-reports: "https://github.com/ocsigen/js_of_ocaml/issues"
  depends: [
    "ocaml" {>= "4.02.0" & < "4.07.0"}
    "jbuilder" {build & >= "1.0+beta17"}
    "cmdliner"
    "cppo" {>= "1.1.0"}
    "ocamlfind"
    "yojson"
  ]
  conflicts: [
    "ocamlfind" {< "1.5.1"}
    "js_of_ocaml" {< "3.0"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/ocsigen/js_of_ocaml.git"
  url {
    src: "https://github.com/ocsigen/js_of_ocaml/archive/3.1.0.tar.gz"
    checksum: "md5=b7a03bea097ac6bda3aaaf4b12b82581"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, cmdliner, cppo,
  findlib, yojson }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.0" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion ocaml) "4.07.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta17";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion cppo) "1.1.0";
assert !stdenv.lib.versionOlder (stdenv.lib.getVersion findlib) "1.5.1";

stdenv.mkDerivation rec {
  pname = "js_of_ocaml-compiler";
  version = "3.1.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocsigen/js_of_ocaml/archive/3.1.0.tar.gz";
    sha256 = "0f1xpj7qg9l5d6c2055yf4vmd0mc4xsybrfpm20lz06lh9ab2w3r";
  };
  buildInputs = [
    ocaml jbuilder cmdliner cppo findlib yojson ];
  propagatedBuildInputs = [
    ocaml jbuilder cmdliner cppo findlib yojson ];
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
