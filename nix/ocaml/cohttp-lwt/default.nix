/*opam-version: "2.0"
  name: "cohttp-lwt"
  version: "1.0.2"
  synopsis: "An OCaml library for HTTP clients and servers"
  description: """
  [![Join the chat at
  https://gitter.im/mirage/ocaml-cohttp](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/mirage/ocaml-cohttp?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
  
  Cohttp is an OCaml library for creating HTTP daemons. It has a portable
  HTTP parser, and implementations using various asynchronous
  programming
  libraries:
  
  * `Cohttp_lwt_unix` uses the [Lwt](https://ocsigen.org/lwt/) library, and
    specifically the UNIX bindings.
  * `Cohttp_async` uses the
  [Async](https://realworldocaml.org/v1/en/html/concurrent-programming-with-async.html)
    library.
  * `Cohttp_lwt` exposes an OS-independent Lwt interface, which is used
    by the [Mirage](https://mirage.io/) interface to generate standalone
    microkernels (use the cohttp-mirage subpackage).
  * `Cohttp_lwt_xhr` compiles to a JavaScript module that maps the Cohttp
    calls to XMLHTTPRequests.  This is used to compile OCaml libraries like
    the GitHub bindings to JavaScript and still run efficiently.
  
  You can implement other targets using the parser very easily. Look at the
  `IO`
  signature in `lib/s.mli` and implement that in the desired backend.
  
  You can activate some runtime debugging by setting `COHTTP_DEBUG` to
  any
  value, and all requests and responses will be written to stderr. 
  Further
  debugging of the connection layer can be obtained by setting
  `CONDUIT_DEBUG`
  to any value."""
  maintainer: "anil@recoil.org"
  authors: [
    "Anil Madhavapeddy"
    "Stefano Zacchiroli"
    "David Sheets"
    "Thomas Gazagnaire"
    "David Scott"
    "Rudi Grinberg"
    "Andy Ray"
  ]
  license: "ISC"
  tags: ["org:mirage" "org:xapi-project"]
  homepage: "https://github.com/mirage/ocaml-cohttp"
  bug-reports: "https://github.com/mirage/ocaml-cohttp/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "jbuilder" {build & >= "1.0+beta10"}
    "cohttp" {>= "1.0.0"}
    "lwt"
  ]
  conflicts: [
    "lwt" {< "2.5.0"}
  ]
  build: [
    ["jbuilder" "subst" "-n" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-cohttp.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-cohttp/releases/download/v1.0.2/cohttp-1.0.2.tbz"
    checksum: "md5=d0a46e32911773862e1a9b420c0058bc"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, cohttp, lwt,
  findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.03.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta10";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion cohttp) "1.0.0";
assert !stdenv.lib.versionOlder (stdenv.lib.getVersion lwt) "2.5.0";

stdenv.mkDerivation rec {
  pname = "cohttp-lwt";
  version = "1.0.2";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v1.0.2/cohttp-1.0.2.tbz";
    sha256 = "1x87laql7ksfq9324iq3yrx81dfjdm0knd40h880d02ny6g299v4";
  };
  buildInputs = [
    ocaml jbuilder cohttp lwt findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder cohttp lwt ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] (stdenv.lib.optionals
    doCheck [ "'jbuilder'" "'runtest'" "'-p'" pname "'-j'" "1" ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
