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
    ./day1
    ./day2
    ./day3
    ./day4
    ./day5
    ./day6
    ./day7
    ./day8
    ./day9
    ./day10
    ./day11
  ])
