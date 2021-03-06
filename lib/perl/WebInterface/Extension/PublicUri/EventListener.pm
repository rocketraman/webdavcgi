#########################################################################
# (C) ZE CMS, Humboldt-Universitaet zu Berlin
# Written 2014 by Daniel Rohde <d.rohde@cms.hu-berlin.de>
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

package WebInterface::Extension::PublicUri::EventListener;

use strict;
use warnings;

our $VERSION = '2.0';

use base qw( Events::EventListener WebInterface::Extension::PublicUri::Common);

use DefaultConfig
  qw( $DOCUMENT_ROOT $PATH_TRANSLATED $REQUEST_URI $VIRTUAL_BASE );

sub new {
    my $this  = shift;
    my $class = ref($this) || $this;
    my $self  = {};
    bless $self, $class;
    $self->{config} = shift;
    $self->{db}     = $self->{config}->{db};
    return $self;
}

sub register {
    my ( $self, $channel ) = @_;
    $self->init_defaults();
    $channel->add( [ 'FILECOPIED', 'PROPFIND', 'OPTIONS' ], $self );
    return 1;
}

sub receive {
    my ( $self, $event, $data ) = @_;
    if ( $event eq 'FILECOPIED' ) {
        $self->handle_file_copied_event($data);
    }
    elsif ( $event eq 'OPTIONS' ) {
        $self->handle_webdav_request($data);
    }
    return 1;
}

sub handle_webdav_request {
    my ( $self, $data ) = @_;
    if ( ${$data}{file} =~ /^$DOCUMENT_ROOT([^\/]+)(.*)?$/xms ) {
        my ( $code, $path ) = ( $1, $2 );
        my $fn = $self->get_file_from_code($code);
        return
          if ( !$fn
            || !$self->is_public_uri( $fn, $code, $self->get_seed($fn) ) );

        $DOCUMENT_ROOT = $fn;
        $DOCUMENT_ROOT .= $DOCUMENT_ROOT !~ /\/$/xms ? q{/} : q{};
        $PATH_TRANSLATED = $fn . $path;
        $VIRTUAL_BASE    = ${$self}{virtualbase} . $code . q{/?};
        if ( $self->{config}->{backend}->isDir($PATH_TRANSLATED) ) {
            $PATH_TRANSLATED .= $PATH_TRANSLATED !~ /\/$/xms ? q{/} : q{};
            $REQUEST_URI .= $REQUEST_URI !~ /\/$/xms ? q{/} : q{};
        }
    }
    return;
}

sub handle_file_copied_event {
    my ( $self, $data ) = @_;
    my $dst = ${$data}{destination};
    my $db  = $self->{config}->{db};
    $dst =~ s/\/$//xms;
    $db->db_deletePropertiesRecursiveByName( $dst,
        ${$self}{namespace} . ${$self}{propname} );
    $db->db_deletePropertiesRecursiveByName( $dst,
        ${$self}{namespace} . ${$self}{seed} );
    $db->db_deletePropertiesRecursiveByName( $dst,
        ${$self}{namespace} . ${$self}{orig} );
    return;
}
1;
