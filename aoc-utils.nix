rec
{
  lib = import <nixpkgs/lib>;
  inherit (lib.lists) foldr;
  sum = foldr (a: b: a + b) 0;
  minInt = -9223372036854775807 - 1;
  max = foldr (a: b:
    if a > b
    then a
    else b)
  minInt;
}
