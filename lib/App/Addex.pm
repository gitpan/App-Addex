#!/usr/bin/perl
use strict;
use warnings;

package App::Addex;

use Carp ();
# use Encode ();
# use Unicode::Normalize ();

=head1 NAME

App::Addex - generate mail tool configuration from an address book

=head1 VERSION

version 0.004

  $Id: /my/cs/projects/App-Addex/trunk/lib/App/Addex.pm 31559 2007-05-10T03:08:11.053586Z rjbs  $

=cut

our $VERSION = '0.004';

=head1 DESCRIPTION

This module iterates through all the entries in an address book and produces
configuration file based on the entries in the address book, using configured
output plugins.

It is meant to be run with the F<addex> command, which is bundled as part of
this software distribution.

=head1 METHODS

B<Achtung!>  The API to this code may very well change.  It is almost certain
to be broken into smaller pieces, to support alternate sources of entries, and
it might just get plugins.

=head2 new

  my $addex = App::Addex->new(\%arg);

This method returns a new Addex.

Valid paramters are:

  classes    - a hashref of plugin/class pairs, described below

Valid keys for the F<classes> parameter are:

  addressbook - the App::Addex::AddressBook subclass to use (required)
  output      - an array of output producers (required)

For each class given, an entry in C<%arg> may be given, which will be used to
initialize the plugin before use.

=cut

sub new {
  my ($class, $arg) = @_;

  my $self = bless {} => $class;

  # XXX: keep track of seen/unseen classes; carp if some go unused?
  # -- rjbs, 2007-04-06

  for my $core (qw(addressbook)) {
    my $class = $arg->{classes}{$core}
      or Carp::confess "no $core class provided";

    $self->{$core} = $self->_initialize_plugin($class, $arg->{$class});
  }

  my @output_classes = @{ $arg->{classes}{output} || [] }
    or Carp::confess "no output classes provided";

  my @output_plugins;
  for my $class (@output_classes) {
    push @output_plugins, $self->_initialize_plugin($class, $arg->{$class});
  }
  $self->{output} = \@output_plugins;

  return bless $self => $class;
}

sub _initialize_plugin {
  my ($self, $class, $arg) = @_;

  eval "require $class" or die;
  return $class->new($arg ? $arg : {});
}

=head2 addressbook

  my $abook = $addex->addressbook;

This method returns the App::Addex::AddressBook object.

=cut

sub addressbook { $_[0]->{addressbook} }

=head2 output_plugins

This method returns all of the output plugin objects.

=cut

sub output_plugins {
  my ($self) = @_;
  return @{ $self->{output} };
}

=head2 run

  App::Addex->new({ ... })->run;

This method performs all the work expected of an Addex: it iterates through the
entries, writing the relevant information to the relevant files.

=cut

sub run {
  my ($self) = @_;

  for my $entry ($self->addressbook->entries) {
    for my $plugin ($self->output_plugins) {
      $plugin->process_entry($self, $entry);
    }
  }
}

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