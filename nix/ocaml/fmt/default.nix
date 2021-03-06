/*opam-version: "2.0"
  name: "fmt"
  version: "0.8.5"
  synopsis: "OCaml Format pretty-printer combinators"
  description: """
  Fmt exposes combinators to devise `Format` pretty-printing functions.
  
  Fmt depends only on the OCaml standard library. The optional
  `Fmt_tty`
  library that allows to setup formatters for terminal color output
  depends on the Unix library. The optional `Fmt_cli` library that
  provides command line support for Fmt depends on [`Cmdliner`][cmdliner].
  
  Fmt is distributed under the ISC license.
  
  [cmdliner]: http://erratique.ch/software/cmdliner"""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: ["Daniel Bünzli <daniel.buenzl i@erratique.ch>" "Gabriel
  Radanne"]
  license: "ISC"
  tags: ["string" "format" "pretty-print" "org:erratique"]
  homepage: "http://erratique.ch/software/fmt"
  doc: "http://erratique.ch/software/fmt"
  bug-reports: "https://github.com/dbuenzli/fmt/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build & >= "0.9.0"}
    "result"
    "uchar"
  ]
  depopts: ["base-unix" "cmdliner"]
  conflicts: [
    "cmdliner" {< "0.9.8"}
  ]
  build: [
    "ocaml"
    "pkg/pkg.ml"
    "build"
    "--dev-pkg"
    "%{pinned}%"
    "--with-base-unix"
    "%{base-unix:installed}%"
    "--with-cmdliner"
    "%{cmdliner:installed}%"
  ]
  dev-repo: "git+http://erratique.ch/repos/fmt.git"
  url {
    src: "http://erratique.ch/software/fmt/releases/fmt-0.8.5.tbz"
    checksum: "md5=77b64aa6f20f09de28f2405d6195f12c"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  result, uchar, base-unix ? null, cmdliner ? null }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion topkg) "0.9.0";
assert !stdenv.lib.versionOlder (stdenv.lib.getVersion cmdliner) "0.9.8";

stdenv.mkDerivation rec {
  pname = "fmt";
  version = "0.8.5";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://erratique.ch/software/fmt/releases/fmt-0.8.5.tbz";
    sha256 = "1zj9azcxcn6skmb69ykgmi9z8c50yskwg03wqgh87lypgjdcz060";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg result uchar ]
  ++
  stdenv.lib.optional
  (base-unix
  !=
  null)
  base-unix
  ++
  stdenv.lib.optional
  (cmdliner
  !=
  null)
  cmdliner;
  propagatedBuildInputs = [
    ocaml topkg result uchar ]
  ++
  stdenv.lib.optional
  (base-unix
  !=
  null)
  base-unix
  ++
  stdenv.lib.optional
  (cmdliner
  !=
  null)
  cmdliner;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--dev-pkg'" "false"
      "'--with-base-unix'"
      "${if base-unix != null then "true" else "false"}" "'--with-cmdliner'" "${if
                                                                    cmdliner
                                                                    != null
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" ] ];
      preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
      [ ];
      installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
      createFindlibDestdir = true;
    }
