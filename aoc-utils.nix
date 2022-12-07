rec {
  nixpkgs = import (builtins.fetchTarball {
    name = "nixpkgs-unstable";
    url = "https://github.com/nixos/nixpkgs/archive/813836d64fa57285d108f0dbf2356457ccd304e3.tar.gz";
    sha256 = "02d97x8zkrzbmdwn28y67qq4nai7wn4wzw13l1fqpvq10kq04gw5";
  }) {};
  lib = nixpkgs.lib;
  inherit (lib.lists) foldr head tail length filter;
  sum = foldr (a: b: a + b) 0;
  minInt = -9223372036854775807 - 1;
  maxInt = 9223372036854775807;
  max = foldr (a: b:
    if a > b
    then a
    else b)
  minInt;
  uncurry = f: lst: f (head lst) (head (tail lst));
  count = f: xs: length (filter f xs);
}
