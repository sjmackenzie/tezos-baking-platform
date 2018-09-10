/*opam-version: "2.0"
  name: "ppx_derivers"
  version: "1.0"
  synopsis: "Shared [@@deriving] plugin registry"
  description: """
  Ppx_derivers is a tiny package whose sole purpose is to allow
  ppx_deriving and ppx_type_conv to inter-operate gracefully when linked
  as part of the same ocaml-migrate-parsetree driver."""
  maintainer: "jeremie@dimino.org"
  authors: "Jérémie Dimino"
  license: "BSD3"
  homepage: "https://github.com/ocaml-ppx/ppx_derivers"
  bug-reports: "https://github.com/ocaml-ppx/ppx_derivers/issues"
  depends: [
    "ocaml"
    "jbuilder" {build & >= "1.0+beta7"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git://github.com/ocaml-ppx/ppx_derivers.git"
  url {
    src: "https://github.com/ocaml-ppx/ppx_derivers/archive/1.0.tar.gz"
    checksum: [
      "md5=4ddce8f43fdb9b0ef0ab6a7cbfebc3e3"
     
  "sha256=b03c9a2cd9d3d250761d60790808d31097e4e6d5d84aa67d720a75d5b6137456"
     
  "sha512=2e2437094362088f9a1601ca3c2f0b82ec079b9a34e502234aef36158ea7a3f2236f1d2526df1a75bcb851346ebaaf717eaf72253935f7ea4024d3dc20512e85"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare jbuilder "1.0+beta7") >= 0;

stdenv.mkDerivation rec {
  pname = "ppx_derivers";
  version = "1.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml-ppx/ppx_derivers/archive/1.0.tar.gz";
    sha256 = "0mkl2fvdax8af9yscjnqspkf95qhsc40hyb03mv51lnkv4n9lg5h";
  };
  buildInputs = [
    ocaml jbuilder findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder ];
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
