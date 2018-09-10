/*opam-version: "2.0"
  name: "cpuid"
  version: "0.1.1"
  synopsis: "Detect CPU features"
  description: """
  cpuid allows detection of CPU features from OCaml.
  
  cpuid is distributed under the ISC license.
  
  ## Installation
  
  cpuid can be installed with `opam`:
  
      opam install cpuid
  
  If you don't use `opam` consult the [`opam`](opam) file for
  build
  instructions.
  
  ## Documentation
  
  The documentation and API reference is automatically generated by
  `ocamldoc` from the interfaces. It can be consulted [online][doc]
  and there is a generated version in the `doc` directory of
  the
  distribution.
  
  [doc]: https://pqwy.github.io/cpuid/doc
  
  [![Build
  Status](https://travis-ci.org/pqwy/cpuid.svg?branch=master)](https://travis-ci.org/pqwy/cpuid)"""
  maintainer: "David Kaloper Meršinjak <david@numm.org>"
  authors: "David Kaloper Meršinjak <david@numm.org>"
  license: "ISC"
  homepage: "https://github.com/pqwy/cpuid"
  doc: "https://pqwy.github.io/cpuid/doc"
  bug-reports: "https://github.com/pqwy/cpuid/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "ocb-stubblr" {build}
    "result"
  ]
  conflicts: [
    "ocb-stubblr" {< "0.1.0"}
  ]
  build: [
    "ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%" "--tests"
  "false"
  ]
  dev-repo: "git+https://github.com/pqwy/cpuid.git"
  url {
    src:
     
  "https://github.com/pqwy/cpuid/releases/download/v0.1.1/cpuid-0.1.1.tbz"
    checksum: "md5=717a6bf371bd083ea588ccd96f328dc2"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  ocb-stubblr, result }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01.0";
assert !stdenv.lib.versionOlder (stdenv.lib.getVersion ocb-stubblr) "0.1.0";

stdenv.mkDerivation rec {
  pname = "cpuid";
  version = "0.1.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/pqwy/cpuid/releases/download/v0.1.1/cpuid-0.1.1.tbz";
    sha256 = "0bl6094glf6551qsl8syxn08hyji6jsg286l84dq5g7djr2z8ykx";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg ocb-stubblr result ];
  propagatedBuildInputs = [
    ocaml result ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" "'--tests'"
      "'false'" ]
    ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
