package Lingua::PT::Words2Nums;

use 5.008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	word2num
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	word2num
);

our $VERSION = '1.01';

=head1 NAME

Lingua::PT::Words2Nums - Converts Portuguese words to numbers

=head1 SYNOPSIS

  use Lingua::PT::Words2Nums;

  $result = num2word("cinco");
  # $result now holds 5

=head1 DESCRIPTION

Words2Nums converts Portuguese words to numbers (works with numbers
ranging from 0 to 999.999.999.999.999.999).

Not all possible ways to write a number have been implemented (some
people write "nove mil novecentos e um", some people write "nove mil,
novecentos e um"; Words2Nums currently supports only the first way,
without commas; also, the word "bili�o" is supported, but not "bilh�o").

=cut

my (%values,@values,%bigvalues,@bigvalues);

BEGIN {
  %values = (
    mil			=> 1000,

    novecentos		=> 900,
    oitocentos		=> 800,
    setecentos		=> 700,
    seiscentos		=> 600,
    quinhentos		=> 500,
    quatrocentos	=> 400,
    trezentos		=> 300,
    duzentos		=> 200,
    cem			=> 100,

    cento		=> 100,

    noventa		=> 90,
    oitenta		=> 80,
    setenta		=> 70,
    sessenta		=> 60,
    cinquenta		=> 50,
    quarenta		=> 40,
    trinta		=> 30,
    vinte		=> 20,

    dezanove		=> 19,
    dezoito		=> 18,
    dezassete		=> 17,
    dezasseis		=> 16,
    quinze		=> 15,
    catorze		=> 14,
    treze		=> 13,
    doze		=> 12,
    onze		=> 11,
    dez			=> 10,

    nove		=> 9,
    oito		=> 8,
    sete		=> 7,
    seis		=> 6,
    cinco		=> 5,
    quatro		=> 4,
    'tr�s'		=> 3,
    dois		=> 2,
    um			=> 1,
  );

  @values = sort {$values{$b} <=> $values{$a}} keys %values;

  %bigvalues = (
    bili => 1000000000000,
    milh => 1000000,
  );

  @bigvalues = sort {$bigvalues{$b} <=> $bigvalues{$a}} keys %bigvalues;

}

sub word2num {
  $_ = shift || return undef;
  my $result = 0;

  for my $val (@bigvalues) {
    my $expr = "${val}�es|${val}�o";

    if (s/(.+)mil(?=.*(?:$expr))//) {
      my $big = $1;
      for my $value (@values) {
        $big =~ s/$value/
                  $result += ($values{$value} * $bigvalues{$val} * 1000)/e;
      }
    }

    if (s/(.+)(?:$expr)//) {
      my $sma = $1;
      for my $value (@values) {
        $sma =~ s/$value/
                  $result += ($values{$value} * $bigvalues{$val})/e;
      } 
    }

  }

  if (s/(.+?)mil//) {
    my $thousands = $1;
    if ($thousands =~ /^\s*e?\s*$/) {
      $result += 1000;
    }
    else {
      for my $value (@values) {
	$thousands =~ s/$value/$result += ($values{$value} * 1000)/e;
      }
    }
  }

  for my $value (@values) {
    s/$value/$result += $values{$value}/e;
  }

  $result;
}

1;
__END__

=head1 MESSAGE FROM THE AUTHOR

If you're using this module, please drop me a line to my e-mail. Tell
me what you're doing with it. Also, feel free to suggest new
bugs^H^H^H^H^H features O:-)

=head1 AUTHOR

Jose Alves de Castro, E<lt>cog [at] cpan [dot] org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004 by Jose Alves de Castro

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
