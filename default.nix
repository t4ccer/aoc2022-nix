let
  expected = import ./answers.nix;

  # mkDay :: path -> {name :: string, value :: {day1 :: int|string, day2 :: int|string}}
  mkDay = path: let
    name = builtins.baseNameOf path;
    computed = import path;
    checkAnswer = part: let
      e = expected.${name}.${part};
      a = computed.${part};
    in
      if e == a
      then a
      else
        throw ''
          Answer missmatch in ${name} - ${part}
          Expected: ${toString e}
          Got:      ${toString a}
        '';
  in {
    inherit name;
    value = {
      part1 = checkAnswer "part1";
      part2 = checkAnswer "part2";
    };
  };
in
  builtins.listToAttrs (map mkDay [
    ./day01
    ./day02
    ./day03
    ./day04
    ./day05
    ./day06
    ./day07
    ./day08
    ./day09
    ./day10
    ./day11
  ])
