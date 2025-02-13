{ ... }:

final: prev: {
    lldb = prev.lldb.overrideAttrs (oldAttrs: {
        dontCheckForBrokenSymlinks = true;
    });
}
