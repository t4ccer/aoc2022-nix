let
  inherit (import ../aoc-utils.nix) lib;
  inherit (builtins) readFile length elem tail all substring;
  inherit (lib.strings) stringToCharacters;
  input = readFile ./input;
  allAreDifferent = lst:
    if (length lst <= 1)
    then true
    else !(all (x: elem x (tail lst)) lst) && (allAreDifferent (tail lst));
  go = len: str: n:
    if (allAreDifferent (stringToCharacters (substring n len str)))
    then n + len
    else go len str (n + 1);

  part1 = go 4 input 0;
  part2 = go 14 input 0;
in {
  inherit part1 part2;
}
