let
  inherit (import ../aoc-utils.nix) lib sum chop lines words unlines;
  inherit (builtins) readFile;
  inherit (lib.strings) toInt concatStrings;
  inherit (lib.trivial) mod;
  inherit (lib.lists) elemAt foldl' range length head filter;

  input = readFile ./input;

  hasArgument = opcode:
    {
      noop = false;
      addx = true;
    }
    .${opcode};

  initialState = {
    regX = 1;
    cycles = 0;
    log = [];
  };

  parseLine = ln: let
    ws = words ln;
    opcode = elemAt ws 0;
    argument =
      if hasArgument opcode
      then toInt (elemAt ws 1)
      else null;
  in {
    inherit opcode argument;
  };

  numberOfCycles = opcode:
    {
      noop = 1;
      addx = 2;
    }
    .${opcode};

  addToX = {
    opcode,
    argument,
  }:
    {
      noop = 0;
      addx = argument;
    }
    .${opcode};

  stepPart1 = st: instr @ {
    opcode,
    argument,
  }: let
    newCycles = st.cycles + numberOfCycles opcode;
    newRegX = st.regX + addToX instr;

    shouldLog = currCycles:
      if mod (currCycles - 20) 40 == 0
      then {
        value = currCycles * st.regX;
        cycles = currCycles;
      }
      else null;

    toLog =
      filter
      (x: x != null)
      (map shouldLog (range (st.cycles + 1) newCycles));
  in {
    cycles = newCycles;
    regX = newRegX;
    log =
      st.log
      ++ (
        if length toLog != 0
        then [(head toLog).value]
        else []
      );
  };

  part1 = sum (foldl' stepPart1 initialState (map parseLine (lines input))).log;

  stepPart2 = st: instr @ {
    opcode,
    argument,
  }: let
    newCycles = st.cycles + numberOfCycles opcode;
    newRegX = st.regX + addToX instr;

    mkPixel = regX: cycles: let
      crtPosX = mod cycles crtWidth;
      isSpriteInFrame = regX - 1 <= crtPosX && crtPosX <= regX + 1;
    in
      if isSpriteInFrame
      then "#"
      else ".";

    pixels =
      map
      (mkPixel st.regX)
      (range st.cycles (newCycles - 1));
  in {
    cycles = newCycles;
    regX = newRegX;
    log = st.log ++ pixels;
  };

  crtWidth = 40;

  # To get readable output to read the answer, run (in project root):
  # nix eval -f . --json day10.part2 | jq -r
  part2 =
    unlines
    (map concatStrings
      (chop crtWidth
        (foldl' stepPart2 initialState
          (map parseLine (lines input)))
        .log));
in {inherit part1 part2;}
