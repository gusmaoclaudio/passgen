use v6;
use lib 'lib';
use Test;
use App::Passgen;

# Testes do módulo
subtest 'generate defaults' => {
    my $p = generate();
    is $p.chars, 16, 'default length 16';
    ok $p ~~ /<[:alpha:\d]>+/, 'has alnum';
}

subtest 'generate symbols + length' => {
    my $p = generate(:length(24), :symbols);
    is $p.chars, 24, 'length 24';
    ok $p ~~ /<[!@#\$%\^&*\-_\+=\?~]>/, 'has symbol';
}

subtest 'no digits' => {
    my $p = generate(:digits(False));
    ok $p !~~ /\d/, 'no digits present';
}

# Smoke test do CLI
my $cmd = $*PROGRAM.parent.parent.add('bin').add('passgen.raku').absolute;

sub run(*@args) {
    run($cmd, |@args).out.slurp(:close).lines;
}

subtest 'cli count and length' => {
    my @out = run('--length=20', '--count=3');
    is @out.elems, 3, '3 lines';
    ok all(@out».chars) == 20, 'each has 20 chars';
}

done-testing;
