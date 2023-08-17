let
  inherit (import ../aoc-utils.nix) lib sum;
  inherit (builtins) readFile substring stringLength elemAt;
  inherit (lib.strings) splitString stringToCharacters charToInt;
  inherit (lib.lists) drop take foldr elem filter head length concatLists;
  input = readFile ./input;
  rucksacks = splitString "\n" input;
  splitSack = s: let
    len = stringLength s;
  in {
    first = stringToCharacters (substring 0 (len / 2) s);
    second = stringToCharacters (substring (len / 2) len s);
  };
  commonElems = xs: ys: filter (x: elem x ys) xs;
  commonInSack = {
    first,
    second,
  }:
    head (commonElems first second);
  itemToPriority = item: let
    code = charToInt item;
  in
    if (code >= 97 && code <= 122)
    then code - 96
    else if (code >= 65 && code <= 90)
    then code - 64 + 26
    else null;
  findBadge = {
    fst,
    snd,
    thr,
  }:
    head (commonElems (commonElems fst snd) thr);
  mkElfGroups = xs:
    if length xs == 0
    then []
    else
      concatLists [
        [
          {
            fst = stringToCharacters (elemAt xs 0);
            snd = stringToCharacters (elemAt xs 1);
            thr = stringToCharacters (elemAt xs 2);
          }
        ]
        (mkElfGroups (drop 3 xs))
      ];
  part1 = sum (map (sack: itemToPriority (commonInSack (splitSack sack))) rucksacks);
  part2 = sum (map (group: itemToPriority (findBadge group)) (mkElfGroups rucksacks));
in {
  inherit part1 part2;
}
