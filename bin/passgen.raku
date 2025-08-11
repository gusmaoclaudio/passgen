#!/usr/bin/env raku
use App::Passgen :generate;

unit sub MAIN(
    Int  :$length = 16,
    Int  :$count  = 1,
    Bool :$upper = True,
    Bool :$lower = True,
    Bool :$digits = True,
    Bool :$symbols = False,
    Bool :$no-ambiguous = False,
    Bool :$help = False
) {
    if $help {
        say q:to/USAGE/;
        passgen.raku — gerador de senhas

        USO:
          passgen.raku [--length=<n>] [--count=<n>]
                        [--upper|--no-upper] [--lower|--no-lower]
                        [--digits|--no-digits] [--symbols]
                        [--no-ambiguous] [--help]
        USAGE
        exit 0;
    }

    for ^$count {
        say generate(:$length, :$upper, :$lower, :$digits, :$symbols, :$no-ambiguous);
    }
}
