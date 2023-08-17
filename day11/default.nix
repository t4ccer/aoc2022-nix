let
  inherit (import ../aoc-utils.nix) lib lines words deepForce uncurry uncurry3 lcm;
  inherit (builtins) readFile listToAttrs;
  inherit (lib.strings) toInt concatStrings splitString;
  inherit (lib.trivial) mod;
  inherit (lib.lists) elemAt foldl' range length head drop partition sort take;
  inherit (lib.attrsets) recursiveUpdate hasAttr mapAttrsToList;

  input = readFile ./input;
  inputLines = lines input;

  mkArgument = arg:
    if arg == "old"
    then "old"
    else toInt arg;

  mkOperation = lhs: symbol: rhs: {
    lhs = mkArgument lhs;
    rhs = mkArgument rhs;
    inherit symbol;
  };

  evalOperation = op: old: let
    func =
      {
        "+" = lhs: rhs: lhs + rhs;
        "*" = lhs: rhs: lhs * rhs;
      }
      .${op.symbol};
    getArgument = arg:
      if arg == "old"
      then old
      else arg;
  in
    func (getArgument op.lhs) (getArgument op.rhs);

  parseInput = offset:
    if offset > length inputLines
    then []
    else let
      monkeyNo =
        head (splitString ":" (elemAt (words (elemAt inputLines (offset + 0))) 1));
      items =
        map toInt (splitString "," (concatStrings (drop 4 (words (elemAt inputLines (offset + 1))))));
      operationStr = drop 5 (words (elemAt inputLines (offset + 2)));
      operation =
        uncurry3 mkOperation operationStr;
      testDivisible =
        toInt (elemAt (words (elemAt inputLines (offset + 3))) 5);
      ifTrue =
        elemAt (words (elemAt inputLines (offset + 4))) 9;
      ifFalse =
        elemAt (words (elemAt inputLines (offset + 5))) 9;

      monkey = {
        name = monkeyNo;
        value = {
          inherit items operation testDivisible ifTrue ifFalse;
          inspections = 0;
        };
      };
    in
      [monkey] ++ parseInput (offset + 7);

  initialMonkeys = listToAttrs (parseInput 0);

  monkeyLcm = foldl' lcm 1 (mapAttrsToList
    (_: m: m.testDivisible)
    initialMonkeys);

  mkRoundStep = operationWrapperFunc: currMonkeyNo: monkeys:
    if !hasAttr (toString currMonkeyNo) monkeys
    then monkeys
    else let
      currMonkey = monkeys.${toString currMonkeyNo};
      inspected = map (item: operationWrapperFunc (evalOperation (currMonkey.operation) item)) currMonkey.items;
      results = partition (item: (mod item currMonkey.testDivisible) == 0) inspected;

      oldFalse = monkeys.${currMonkey.ifFalse}.items;
      newFalse = oldFalse ++ results.wrong;

      oldTrue = monkeys.${currMonkey.ifTrue}.items;
      newTrue = oldTrue ++ results.right;

      newMonkeys = deepForce (recursiveUpdate monkeys {
        ${toString currMonkeyNo} = {
          items = [];
          inspections = currMonkey.inspections + length inspected;
        };

        ${currMonkey.ifFalse} = {
          items = newFalse;
        };

        ${currMonkey.ifTrue} = {
          items = newTrue;
        };
      });
    in
      mkRoundStep operationWrapperFunc (currMonkeyNo + 1) newMonkeys;

  mkPart = stepFunc: rounds:
    uncurry
    (a: b: a * b)
    (take 2
      (sort
        (a: b: a > b)
        (mapAttrsToList
          (_: m: m.inspections)
          (foldl'
            (acc: _: mkRoundStep stepFunc 0 acc)
            initialMonkeys
            (range 1 rounds)))));

  part1 = mkPart (item: item / 3) 20;
  part2 = mkPart (item: mod item monkeyLcm) 10000;
in {inherit part1 part2;}
