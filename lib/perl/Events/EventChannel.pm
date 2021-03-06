#########################################################################
# (C) ZE CMS, Humboldt-Universitaet zu Berlin
# Written 2013 by Daniel Rohde <d.rohde@cms.hu-berlin.de>
#########################################################################
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#########################################################################
package Events::EventChannel;

use strict;
use warnings;

our $VERSION = '2.0';

use CGI::Carp;

sub new {
    my $class = shift;
    return bless {}, $class;
}
sub free {
    my ($self) = @_;
    foreach my $ls (keys %{$self->{event}}) {
        foreach my $i (0 .. $#{$self->{event}->{$ls}}) {
            my $l = $self->{event}->{$ls}->[$i];
            if ($l->can('free')) { $l->free(); }
            $self->{event}->{$ls}->[$i] = undef;
        }
        delete $self->{event}->{$ls};
    }
    delete $self->{event};
    return $self;
}
sub add {
    my ( $self, $event, $listener ) = @_;
    if ( defined $listener ) {
        $listener->isa('Events::EventListener')
          or croak "I need a Events::EventListener for $event";
    }

    if ( !$self->{event}->{ $event || 'ALL' } ) { $self->{event}->{ $event || 'ALL' } = []; }

    if ( !defined $event ) {
        push @{ $self->{event}->{ALL} }, $listener;
    }
    elsif ( ref($event) eq 'ARRAY' ) {
        foreach my $e ( @{$event} ) {
            push @{ $self->{event}->{$e} }, $listener;
        }
    }
    else {
        push @{ $self->{event}->{$event} }, $listener;
    }
    return 1;
}

sub broadcast {
    my ( $self, $event, @data ) = @_;
    my @listeners = ( @{ $self->{event}->{$event} // [] }, @{ $self->{event}->{ALL} // [] } );
    foreach my $listener (@listeners) {
        $listener->receive( $event, @data );
    }
    return 1;
}

1;
