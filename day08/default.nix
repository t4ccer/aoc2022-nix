let
  inherit (import ../aoc-utils.nix) lib max;
  inherit (builtins) readFile;
  inherit (lib.strings) splitString stringToCharacters toInt;
  inherit (lib.lists) elemAt length head drop take all range concatMap count reverseList;

  input = readFile ./input;
  grid = map (ln: map toInt (stringToCharacters ln)) (splitString "\n" input);

  splitAt = n: list: {
    left = take n list;
    right = drop (n + 1) list;
  };
  heightAt = grid: x: y: elemAt (elemAt grid y) x;
  rowAt = grid: y: elemAt grid y;
  colAt = grid: x: map (row: elemAt row x) grid;
  flatMapGrid = f: grid:
    concatMap (y: (map (x: f grid x y) (range 0 (length (head grid) - 1)))) (range 0 (length grid - 1));

  isVisible = grid: x: y: let
    row = splitAt x (rowAt grid y);
    col = splitAt y (colAt grid x);
    h = heightAt grid x y;
  in
    all (v: v < h) row.left
    || all (v: v < h) row.right
    || all (v: v < h) col.left
    || all (v: v < h) col.right;
  part1 = count (x: x) (flatMapGrid isVisible grid);

  visibleTrees = ts: h:
    if length ts == 0
    then 0
    else if elemAt ts 0 >= h
    then 1
    else 1 + visibleTrees (drop 1 ts) h;
  scenicScore = grid: x: y: let
    row = splitAt x (rowAt grid y);
    col = splitAt y (colAt grid x);
    h = heightAt grid x y;
    top = visibleTrees (reverseList col.left) h;
    bottom = visibleTrees col.right h;
    left = visibleTrees (reverseList row.left) h;
    right = visibleTrees row.right h;
  in
    top * bottom * left * right;
  part2 = max (flatMapGrid scenicScore grid);
in {
  inherit part1 part2;
}
