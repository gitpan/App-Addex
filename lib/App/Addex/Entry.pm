#!/usr/bin/perl
use strict;
use warnings;

package App::Addex::Entry;

use Mixin::ExtraFields::Param -fields => {
  driver  => 'HashGuts',
  moniker => 'field',
  id      => undef,
};

use Carp ();

=head1 NAME

App::Addex::Entry - an entry in your address book

=head1 VERSION

version 0.023

=cut

our $VERSION = '0.023';

=head1 METHODS

B<Achtung!>  The API to this code may very well change.

=head2 new

  my $entry = App::Addex::Entry->new(\%arg);

This method returns an Addex Entry object.

Valid parameters (sure to change) are:

  name   - a full name (required)
  nick   - a nickname (optional)
  emails - an arrayref of email addresses (required)

=cut

sub new {
  my ($class, $arg) = @_;

  # XXX: do some validation -- rjbs, 2007-04-06
  my $self = {
    name   => $arg->{name},
    nick   => $arg->{nick},
    emails => $arg->{emails},
  };

  bless $self => $class;

  $self->field(%{ $arg->{fields} }) if $arg->{fields};

  return $self;
}

=head2 name

=head2 nick

These methods return the value of the property they name.

=cut

sub name { $_[0]->{name} }
sub nick { $_[0]->{nick} }

=head2 emails

This method returns the entry's email addresses.  In scalar context it returns
the number of addresses.

=cut

sub emails { @{ $_[0]->{emails} } }

=head2 field

  my $value = $entry->field($name);

  $entry->field($name => $value);

This method is generated by L<Mixin::ExtraFields::Param|Mixin::ExtraFields::Param>.

=cut

=head1 AUTHOR

Ricardo SIGNES, C<< <rjbs@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT

Copyright 2006-2007 Ricardo Signes, all rights reserved.

This program is free software; you may redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
