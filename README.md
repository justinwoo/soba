# soba

packages.dhall to local psc-package set

If you don't know what this is, then don't worry about it.

Maybe you should use this instead: https://github.com/justinwoo/psc-package-nix/

## about

```
$ soba
soba: prepare psc-package sets from dhall

Usage:

    soba [command]

Commands:

    insdhall
        generate the local package set from packages.dhall.
        be sure to update `"set": "local"` in psc-packages.json.

    update
        do an update of the local package set from the packages.dhall.

    setup
        do some initial setup for a project (packages.dhall, local package set, config).

    nix
        generate a purs-packages.nix file based on the local package set.
        requires `insdhall` to be run first.

$ soba insdhall
Wrote local package set using packages.dhall.
```

## requirements

See shell.nix for details

* purs
* psc-package
* dhall
* dhall-json
