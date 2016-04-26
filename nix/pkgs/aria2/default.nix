{ stdenv, fetchurl, pkgconfig, autoreconfHook, cacert
, openssl, c-ares, libxml2, sqlite, zlib, libssh2
}:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "https://github.com/tatsuhiro-t/aria2/releases/download/release-${version}/${name}.tar.xz";
    sha256 = "12agwdvvkr34wqhyyfp418dj0k7nbr297qmcd3wj5kkn7brv6gxc";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl c-ares libxml2 sqlite zlib libssh2 ];

  configureFlags = [ "--with-ca-bundle=${cacert}/etc/ssl/certs/ca-bundle.crt" ] ++
    stdenv.lib.optional stdenv.isDarwin [ "--with-openssl" "--without-appletls" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/tatsuhiro-t/aria2;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    maintainers = with maintainers; [ koral jgeerds ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
