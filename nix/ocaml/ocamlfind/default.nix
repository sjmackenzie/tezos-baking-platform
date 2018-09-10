/*opam-version: "2.0"
  name: "ocamlfind"
  version: "1.8.0"
  synopsis: "A library manager for OCaml"
  description: """
  Findlib is a library manager for OCaml. It provides a convention how
  to store libraries, and a file format ("META") to describe the
  properties of libraries. There is also a tool (ocamlfind) for
  interpreting the META files, so that it is very easy to use libraries
  in programs and scripts."""
  maintainer: "Thomas Gazagnaire <thomas@gazagnaire.org>"
  authors: "Gerd Stolpmann <gerd@gerd-stolpmann.de>"
  homepage: "http://projects.camlcity.org/projects/findlib.html"
  bug-reports: "https://gitlab.camlcity.org/gerd/lib-findlib/issues"
  depends: [
    "ocaml" {>= "4.00.0"}
    "conf-m4" {build}
  ]
  build: [
    [
      "./configure"
      "-bindir"
      bin
      "-sitelib"
      lib
      "-mandir"
      man
      "-config"
      "%{lib}%/findlib.conf"
      "-no-custom"
      "-no-topfind" {ocaml:preinstalled}
    ]
    [make "all"]
    [make "opt"] {ocaml:native}
  ]
  install: [
    [make "install"]
    ["install" "-m" "0755" "ocaml-stub" "%{bin}%/ocaml"]
  {ocaml:preinstalled}
  ]
  remove: [
    ["ocamlfind" "remove" "bytes"]
    [
      "./configure"
      "-bindir"
      bin
      "-sitelib"
      lib
      "-mandir"
      man
      "-config"
      "%{lib}%/findlib.conf"
      "-no-topfind" {ocaml:preinstalled}
    ]
    [make "uninstall"]
    ["rm" "-f" "%{bin}%/ocaml"] {ocaml:preinstalled}
  ]
  dev-repo:
  "git+https://gitlab.camlcity.org/gerd/lib-findlib.git"
  extra-files: [
    ["ocamlfind.install" "md5=06f2c282ab52d93aa6adeeadd82a2543"]
    ["ocaml-stub" "md5=181f259c9e0bad9ef523e7d4abfdf87a"]
  ]
  url {
    src: "http://download.camlcity.org/download/findlib-1.8.0.tar.gz"
    checksum: "md5=a710c559667672077a93d34eb6a42e5b"
    mirrors: "http://download2.camlcity.org/download/findlib-1.8.0.tar.gz"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, conf-m4, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.00.0";

stdenv.mkDerivation rec {
  pname = "ocamlfind";
  version = "1.8.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://download.camlcity.org/download/findlib-1.8.0.tar.gz";
    sha256 = "1b97zqjdriqd2ikgh4rmqajgxwdwn013riji5j53y3xvcmnpsyrb";
  };
  postUnpack = "ln -sv ${./ocamlfind.install} \"$sourceRoot\"/ocamlfind.install\nln -sv ${./ocaml-stub} \"$sourceRoot\"/ocaml-stub";
  buildInputs = [
    ocaml conf-m4 findlib ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'./configure'" "'-bindir'" "$out/bin" "'-sitelib'"
      "$OCAMLFIND_DESTDIR" "'-mandir'" "$out/man" "'-config'"
      "$OCAMLFIND_DESTDIR'/findlib.conf'" "'-no-custom'" "'-no-topfind'" ]
    [ "make" "'all'" ] (stdenv.lib.optionals (!stdenv.isMips) [
      "make" "'opt'" ])
    ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'install'" ] [
      "'install'" "'-m'" "'0755'" "'ocaml-stub'" "$out/bin'/ocaml'" ]
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
