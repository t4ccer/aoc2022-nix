rec {
  nixpkgs = import (builtins.fetchTarball {
    name = "nixpkgs-unstable";
    url = "https://github.com/nixos/nixpkgs/archive/1fc281902d7bf2702e7ae556ae5d82abac77d7b9.tar.gz";
    sha256 = "sha256:0w4wcmb641db9kw96xk513875nc3mr3mid9b5n3fg954aj9fqygw";
  }) {};
  lib = nixpkgs.lib;
  inherit (lib.trivial) mod;
  inherit (lib.lists) foldr head tail length filter take drop elemAt;
  inherit (lib.strings) splitString concatStringsSep;

  ### Functions

  # uncurry :: (a -> b -> c) -> ([a, b] -> c)
  uncurry = f: lst: f (head lst) (head (tail lst));

  # uncurry3 :: (a -> b -> c -> d) -> ([a, b, c] -> d)
  uncurry3 = f: lst: f (elemAt lst 0) (elemAt lst 1) (elemAt lst 2);

  ### Lists

  # count :: (a -> bool) -> list a -> int
  count = f: xs: length (filter f xs);

  # chop :: int -> list a -> list (list a)
  chop = len: xs:
    if length xs <= len
    then [xs]
    else [(take len xs)] ++ chop len (drop len xs);

  # words :: string -> list string
  words = splitString " ";

  # unlines :: list string -> string
  unlines = concatStringsSep "\n";

  # lines :: string -> list string
  lines = splitString "\n";

  ### Strict

  # force :: a -> a
  force = x: builtins.seq x x;

  # deepForce :: a -> a
  deepForce = x: builtins.deepSeq x x;

  ### Numerical

  # abs :: int -> int
  abs = x:
    if x < 0
    then -x
    else x;

  # signum :: int -> int
  signum = x:
    if x == 0
    then 0
    else if x < 0
    then -1
    else 1;

  # gcd :: int -> int -> int
  gcd = x: y:
    if y == 0
    then x
    else gcd y (mod x y);

  # lcm :: int -> int -> int
  lcm = x: y: (x / (gcd x y)) * y;

  # sum :: list int -> int
  sum = foldr (a: b: a + b) 0;

  # max :: list int -> int
  max = foldr (a: b:
    if a > b
    then a
    else b)
  minInt;

  # minInt :: int
  minInt = -9223372036854775807 - 1;

  # maxInt :: int
  maxInt = 9223372036854775807;
}
