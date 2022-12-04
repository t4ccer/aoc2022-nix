let
  inherit (import ../aoc-utils.nix) lib count;
  inherit (builtins) readFile elemAt;
  inherit (lib.strings) splitString toInt;
  inherit (lib.lists) filter length;
  input = splitString "\n" (readFile ./input);
  parseEntry = s: let
    ranges = splitString "," s;
    getRange = n: splitString "-" (elemAt ranges n);
    firstRange = getRange 0;
    secondRange = getRange 1;
    getStart = r: toInt (elemAt r 0);
    getEnd = r: toInt (elemAt r 1);
  in {
    first = {
      start = getStart firstRange;
      end = getEnd firstRange;
    };
    second = {
      start = getStart secondRange;
      end = getEnd secondRange;
    };
  };
  areOverlapping1 = {
    first,
    second,
  }:
    (first.start <= second.start && first.end >= second.end)
    || (second.start <= first.start && second.end >= first.end);

  areOverlapping2 = {
    first,
    second,
  }:
    if first.start > second.start
    then
      areOverlapping2 {
        first = second;
        second = first;
      }
    else first.end >= second.start;

  solveUsing = f: count f (map parseEntry input);
  part1 = solveUsing areOverlapping1;
  part2 = solveUsing areOverlapping2;
in {
  inherit part1 part2;
}
