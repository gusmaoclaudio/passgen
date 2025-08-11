use v6;
use lib 'lib';
use Test;
use App::Passgen;

# --- testes do módulo ---
subtest 'defaults' => {
    my $p = generate();
    is $p.chars, 16, 'default length 16';
    ok $p ~~ /<:alnum>+/, 'has alnum';
}

subtest 'length + symbols' => {
    my $p = generate(:length(24), :symbols);
    is $p.chars, 24, 'length 24';
    ok $p ~~ /<[!@#\$%\^&*\-_\+=\?~]>/, 'has at least one symbol';
}

subtest 'no digits' => {
    my $p = generate(:digits(False));
    ok $p !~~ /\d/, 'contains no digits';
}

# --- smoke test do CLI ---
my $cmd = $*PROGRAM.parent.parent.add('bin').add('passgen.raku').absolute;

sub run_cli(*@args) {
    run($cmd, |@args).out.slurp(:close).lines;
}

subtest 'cli count & length' => {
    my @out = run_cli('--length=20', '--count=3');
    is @out.elems, 3, '3 lines';
    ok all(@out».chars) == 20, 'each has 20 chars';
}

done-testing;
