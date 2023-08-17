# NOTE: This is _very_ slow but I don't know how to opitmize it without
# in place mutations, this allocates _lots_ of temporary structures
let
  inherit (import ../aoc-utils.nix) lib deepForce abs signum;
  inherit (builtins) readFile;
  inherit (lib.strings) splitString toInt;
  inherit (lib.lists) elemAt foldl' unique length last replicate;

  input = readFile ./input;
  parseLine = ln: let
    ws = splitString " " ln;
  in {
    dir = elemAt ws 0;
    amt = toInt (elemAt ws 1);
  };

  origin = {
    x = 0;
    y = 0;
  };

  mkInitialStateWithKnots = n: {
    knots = replicate n origin;
    visited = [origin];
  };

  isHeadTouchingTail = head: tail:
    (abs (head.x - tail.x) < 2)
    && (abs (head.y - tail.y) < 2);

  moveHeadOnce = head: dir:
    {
      R = {
        x = head.x + 1;
        y = head.y;
      };
      L = {
        x = head.x - 1;
        y = head.y;
      };
      U = {
        x = head.x;
        y = head.y + 1;
      };
      D = {
        x = head.x;
        y = head.y - 1;
      };
    }
    .${dir};

  moveTailOnce = newHead: tail:
    if isHeadTouchingTail newHead tail
    then tail
    else {
      x = tail.x + signum (newHead.x - tail.x);
      y = tail.y + signum (newHead.y - tail.y);
    };

  moveOnce = st: dir: let
    ropeHead = elemAt st.knots 0;
    ropeTails = builtins.tail st.knots;
    newHead = moveHeadOnce ropeHead dir;
    newKnots =
      foldl' (
        acc: tail: let
          newHead = last acc;
          newTail = moveTailOnce newHead tail;
        in (acc ++ [newTail])
      ) [newHead]
      ropeTails;
  in
    deepForce {
      knots = newKnots;
      visited = st.visited ++ [(last st.knots) (last newKnots)];
    };

  move = st: {
    dir,
    amt,
  }:
    if (amt <= 0)
    then st
    else
      move (moveOnce st dir) {
        inherit dir;
        amt = amt - 1;
      };

  mkPartWithKnots = n:
    builtins.length
    (unique
      (foldl' move (mkInitialStateWithKnots n)
        (map parseLine (splitString "\n" input)))
      .visited);

  part1 = mkPartWithKnots 2;
  part2 = mkPartWithKnots 10;
in {inherit part1 part2;}
