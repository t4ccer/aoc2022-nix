let
  inherit (import ../aoc-utils.nix) lib;
  inherit (builtins) readFile length elem tail all substring;
  inherit (lib.strings) stringToCharacters;
  inherit (lib.lists) unique;
  input = readFile ./input;
  allAreDifferent = lst: unique lst == lst;
  go = len: str: n:
    if (allAreDifferent (stringToCharacters (substring n len str)))
    then n + len
    else go len str (n + 1);

  part1 = go 4 input 0;
  part2 = go 14 input 0;
in {
  inherit part1 part2;
}
