let
  inherit (import ../aoc-utils.nix) lib sum minInt max;
  inherit (lib.strings) toInt splitString;
  inherit (lib.lists) foldr take;
  inherit (builtins) readFile split sort;
  input = readFile ./input;
  caloriesPerElf = map (str: sum (map toInt (splitString "\n" str))) (splitString "\n\n" input);
  part1 = max caloriesPerElf;
  part2 = sum (take 3 (sort (a: b: a > b) caloriesPerElf));
in {
  inherit part1 part2;
}
