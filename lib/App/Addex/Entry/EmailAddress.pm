use strict;
use warnings;
package App::Addex::Entry::EmailAddress;
{
  $App::Addex::Entry::EmailAddress::VERSION = '0.024';
}
# ABSTRACT: an address book entry's email address


sub new {
  my ($class, $arg) = @_;

  $arg = { address => $arg } if not ref $arg;
  undef $arg->{label} if defined $arg->{label} and not length $arg->{label};

  for (qw(sends receives)) {
    $arg->{$_} = 1 unless exists $arg->{$_};
  }

  bless $arg => $class;
}


use overload '""' => 'address';

sub address {
  $_[0]->{address}
}


sub label {
  $_[0]->{label}
}


sub sends    { $_[0]->{sends} }
sub receives { $_[0]->{receives} }

1;

__END__

=pod

=head1 NAME

App::Addex::Entry::EmailAddress - an address book entry's email address

=head1 VERSION

version 0.024

=head1 SYNOPSIS

An App::Addex::Entry::EmailAddress object represents, well, an addess for an
entry.

=head1 METHODS

=head2 new

  my $address = App::Addex::Entry::EmailAddress->new("dude@example.aero");

  my $address = App::Addex::Entry::EmailAddress->new(\%arg);

Valid arguments are:

  address - the contact's email address
  label   - the label for this contact (home, work, etc)
            there is no guarantee that labels are defined or unique

  sends    - if true, this address may send mail; default: true
  receives - if true, this address may receive mail; default: true

=head2 address

This method returns the email address as a string.

=head2 label

This method returns the address label, if any.

=head2 sends

=head2 receives

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2006 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
