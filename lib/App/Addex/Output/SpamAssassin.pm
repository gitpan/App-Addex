use strict;
use warnings;

package App::Addex::Output::SpamAssassin;
{
  $App::Addex::Output::SpamAssassin::VERSION = '0.024';
}
use parent qw(App::Addex::Output::ToFile);
# ABSTRACT: generate SpamAssassin whitelists from an address book


sub process_entry {
  my ($self, $addex, $entry) = @_;

  $self->output("whitelist_from $_") for grep { $_->sends } $entry->emails;
}

1;

__END__

=pod

=head1 NAME

App::Addex::Output::SpamAssassin - generate SpamAssassin whitelists from an address book

=head1 VERSION

version 0.024

=head1 DESCRIPTION

This plugin produces a file that contains a list of SpamAssassin whitelist
declarations.

=head1 METHODS

=head2 process_entry

  $sa_outputter->process_entry($addex, $entry);

This method does the actual writing of configuration to the file.

=head1 CONFIGURATION

The valid configuration parameters for this plugin are:

  filename - the filename to which to write the whitelists

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2006 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
