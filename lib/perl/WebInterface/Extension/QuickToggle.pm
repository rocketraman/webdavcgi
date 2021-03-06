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
#
# SETUP:
# toggles - template file
# disable_filterbox - disables filterbox entry
# enable_apps - enables sidebar menu entry
# enable_pref - enables sidebar menu entry (after preferences)
# disable_statusbar - disables statusbar quick toggles

package WebInterface::Extension::QuickToggle;

use strict;
use warnings;
our $VERSION = '2.0';

use base qw( WebInterface::Extension  );

use vars qw( $ACTION );

use DefaultConfig qw( $PATH_TRANSLATED $REQUEST_URI %EXTENSION_CONFIG );

sub init {
    my ( $self, $hookreg ) = @_;
    my @hooks = qw( css locales javascript );
    if ( !$EXTENSION_CONFIG{QuickToggle}{disable_filterbox} ) {
        push @hooks, 'filterbox';
    }
    if ( $EXTENSION_CONFIG{QuickToggle}{enable_apps} ) {
        push @hooks, 'apps';
    }
    if ( $EXTENSION_CONFIG{QuickToggle}{enable_pref} ) { push @hooks, 'pref'; }
    if ( !$EXTENSION_CONFIG{QuickToggle}{disable_statusbar} ) {
        push @hooks, 'statusbarleft';
    }
    $hookreg->register( \@hooks, $self );
    return $self;
}

sub handle_hook_filterbox {
    my ( $self, $config, $params ) = @_;
    return $self->_handle( 'filterbox', $config, $params );
}

sub handle_hook_apps {
    my ( $self, $config, $params ) = @_;
    return $self->_handle( 'apps', $config, $params );
}

sub handle_hook_pref {
    my ( $self, $config, $params ) = @_;
    return $self->_handle( 'pref', $config, $params );
}

sub handle_hook_statusbarleft {
    my ( $self, $config, $params ) = @_;
    return $self->_handle( 'statusbar', $config, $params );
}

sub _handle {
    my ( $self, $hook, $config, $params ) = @_;
    my $ret =
      $self->render_template( $PATH_TRANSLATED, $REQUEST_URI,
        $self->read_template( $self->config( 'toggles', 'toggles' ) ) );
    return $ret;
}

1;
