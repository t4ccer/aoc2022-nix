let
  inherit (import ../aoc-utils.nix) lib sum uncurry;
  inherit (builtins) readFile;
  inherit (lib.strings) splitString;
  input = readFile ./input;
  shapeToScore = shape:
    {
      X = 1;
      Y = 2;
      Z = 3;
    }
    .${shape};
  outcomeToScore = oponent: me:
    {
      A = {
        X = 3;
        Y = 6;
        Z = 0;
      };
      B = {
        X = 0;
        Y = 3;
        Z = 6;
      };
      C = {
        X = 6;
        Y = 0;
        Z = 3;
      };
    }
    .${oponent}
    .${me};
  calcScore1 = oponent: me: outcomeToScore oponent me + shapeToScore me;

  determineMove = oponent: result:
    {
      A = {
        X = "Z";
        Y = "X";
        Z = "Y";
      };
      B = {
        X = "X";
        Y = "Y";
        Z = "Z";
      };
      C = {
        X = "Y";
        Y = "Z";
        Z = "X";
      };
    }
    .${oponent}
    .${result};
  calcScore2 = oponent: result: calcScore1 oponent (determineMove oponent result);

  withScoreFunc = f: sum (map (str: uncurry f (splitString " " str)) (splitString "\n" input));
  part1 = withScoreFunc calcScore1;
  part2 = withScoreFunc calcScore2;
in {
  inherit part1 part2;
}
