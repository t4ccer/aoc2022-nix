let
  inherit (import ../aoc-utils.nix) lib;
  inherit (builtins) readFile attrValues listToAttrs genList zipAttrsWith;
  inherit (lib.strings) splitString toInt concatStringsSep stringLength stringToCharacters;
  inherit (lib.lists) drop take reverseList concatLists head elemAt foldl' length;

  input = splitString "\n\n" (readFile ./input);

  stackPart = let
    lines = splitString "\n" (elemAt input 0);
    len = length lines;
  in
    map parseStackLine (take (len - 1) lines);
  parseStackLine = ln: let
    len = stringLength ln;
    cs = stringToCharacters ln;
    idxs = genList (n: n) ((len + 1) / 4);
    getElem = n: let
      e = elemAt cs (1 + 4 * n);
    in
      if e == " "
      then []
      else [e];
  in
    listToAttrs (map (n: {
        name = toString (n + 1);
        value = getElem n;
      })
      idxs);
  initState = zipAttrsWith (name: values: concatLists values) stackPart;

  instructions = map parseMoveLine (splitString "\n" (elemAt input 1));
  parseMoveLine = line: let
    p = splitString " " line;
    extract = n: elemAt p n;
  in {
    amt = toInt (extract 1);
    from = extract 3;
    to = extract 5;
  };

  move = f: st: {
    amt,
    from,
    to,
  }: (st
    // {
      "${from}" = drop amt st.${from};
      "${to}" = concatLists [(f (take amt st.${from})) st.${to}];
    });

  getTops = st: concatStringsSep "" (map head (attrValues st));
  headDef = def: lst:
    if length lst == 0
    then def
    else head lst;
  solveWith = f: getTops (foldl' (move f) initState instructions);
  part1 = solveWith reverseList;
  part2 = solveWith (x: x);
in {
  inherit part1 part2;
}
