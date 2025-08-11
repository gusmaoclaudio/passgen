unit module App::Passgen;

sub generate(
    Int :$length = 16,
    Bool :$upper = True,
    Bool :$lower = True,
    Bool :$digits = True,
    Bool :$symbols = False,
    Bool :$no-ambiguous = False
    --> Str
) is export {
    my %chosen = :$upper, :$lower, :$digits, :$symbols;

    my @U = 'A'..'Z';
    my @L = 'a'..'z';
    my @D = '0'..'9';
    my @S = <! @ # $ % ^ & * - _ + = ? ~>;

    my @pool;
    @pool.append(@U) if %chosen<upper>;
    @pool.append(@L) if %chosen<lower>;
    @pool.append(@D) if %chosen<digits>;
    @pool.append(@S) if %chosen<symbols>;

    die "No character set selected." unless @pool;

    my %amb = set <0 O o 1 l I | S 5 2 Z>;
    @pool .= grep({ !$no-ambiguous || ($_ ∉ %amb) });

    # garantir pelo menos 1 de cada categoria ativa
    my @req;
    @req.push(@U.pick) if %chosen<upper>;
    @req.push(@L.pick) if %chosen<lower>;
    @req.push(@D.pick) if %chosen<digits>;
    @req.push(@S.pick) if %chosen<symbols>;

    my $rest = $length - @req.elems;
    die "length too short for the selected categories" if $rest < 0;

    my @chars = flat @req, @pool.pick($rest);
    @chars = @chars.pick(*); # embaralhar
    @chars.join;
}
