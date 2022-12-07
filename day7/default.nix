let
  inherit (import ../aoc-utils.nix) lib sum maxInt;
  inherit (builtins) readFile isInt attrValues isAttrs sort;
  inherit (lib.strings) splitString toInt concatStringsSep;
  inherit (lib.lists) head elemAt take length drop foldl' filter concatMap;
  input = splitString "\n" (readFile ./input);
  parseLine = ln: let
    ws = splitString " " ln;
  in
    if (elemAt ws 0 == "$" && elemAt ws 1 == "cd")
    then interpretDir (elemAt ws 2)
    else if (elemAt ws 0 == "$" && elemAt ws 1 == "ls")
    then (s: s)
    else if (elemAt ws 0 == "dir")
    then (s: s)
    else interpretFile (toInt (elemAt ws 0)) (elemAt ws 1);

  initState = {
    cwd = [];
    files = {};
  };
  interpretDir = dirName: state:
    state
    // {
      cwd =
        if dirName == ".."
        then take (length state.cwd - 1) state.cwd
        else if dirName == "/"
        then []
        else state.cwd ++ [dirName];
    };
  mkNested = oldSet: xs: name: val:
    if xs == []
    then oldSet // {${name} = val;}
    else oldSet // {${head xs} = mkNested (oldSet.${head xs} or {}) (drop 1 xs) name val;};
  interpretFile = size: fileName: state: {
    inherit (state) cwd;
    files = mkNested state.files state.cwd fileName size;
  };
  finalState = (foldl' (state: ln: parseLine ln state) initState input).files;
  getDirSize = dirOrFile:
    if isInt dirOrFile
    then dirOrFile
    else foldl' (s: x: s + getDirSize x) 0 (attrValues dirOrFile);
  getSubDirs = dirOrFile:
    if isInt dirOrFile
    then []
    else filter isAttrs (attrValues dirOrFile);
  getSizesBelow = sizeLimit: dir: let
    curSize = getDirSize dir;
    curDir =
      if curSize < sizeLimit
      then [curSize]
      else [];
    subDirs = getSubDirs dir;
    subDirSizes = concatMap (getSizesBelow sizeLimit) subDirs;
  in
    curDir ++ subDirSizes;
  part1 = sum (getSizesBelow 100000 finalState);

  totalDiskSpace = 70000000;
  requiredUnused = 30000000;
  usedSpace = totalDiskSpace - getDirSize finalState;
  spaceToFree = requiredUnused - usedSpace;
  getAllSizes = getSizesBelow maxInt;
  part2 = head (filter (s: s >= spaceToFree) (sort (a: b: b > a) (getAllSizes finalState)));
in {
  inherit part1 part2;
}
