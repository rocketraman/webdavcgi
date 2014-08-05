#########################################################################
# (C) ssystems, Harald Strack
# Written 2012 by Harald Strack <hstrack@ssystems.de>
# Modified 2013,2014 by Daniel Rohde <d.rohde@cms.hu-berlin.de>
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
# SETUP:
# allowedpostactions - allowed actions regex, default: ^(zipdwnload|diskusage|search|diff)$
# virtualbase - virtual base URI for the public link (default: /public/)
# propname - property name for the share digest
# namespace - XML namespace for public uri property (default: {http://webdavcgi.sf.net/extension/PublicUri/})
package WebInterface::Extension::PublicUriShow;


use strict;

use WebInterface::Extension;
our @ISA = qw( WebInterface::Extension );

use Digest::MD5 qw(md5 md5_hex md5_base64);


#URI CRUD
sub getFileFromCode {
	my ( $self, $code ) = @_;
	my $fna = $$self{db}->db_getPropertyFnByValue( $$self{namespace}.$$self{propname}, $code );
	return $fna ? $$fna[0] : undef;
}

sub init {
	my ($self, $hookreg) = @_;

	$hookreg->register(['posthandler','gethandler'], $self);

	$$self{virtualbase} = $self->config('basepath', '/public/');
	$$self{namespace} = $self->config('namespace', '{http://webdavcgi.sf.net/extension/PublicUri/}');
	$$self{propname} = $self->config('propname', 'public_prop');
	$$self{allowedpostactions} = $self->config('allowedpostactions','^(zipdwnload|diskusage|search|diff)$')
}

#Show icons and handle actions
sub handle {
	my ( $self, $hook, $config, $params ) = @_;
	$self->SUPER::handle($hook, $config, $params);
	if ( $hook eq 'posthandler' ) {
		return $self->handlePublicUriAccess() if $$self{cgi}->param('action')  =~ /$$self{allowedpostactions}/;
		main::printHeaderAndContent(main::getErrorDocument('404 Not Found','text/plain','404 - NOT FOUND'));
		return 1;
	} elsif ($hook eq 'gethandler') {
		return $self->handlePublicUriAccess();
	}
	return 0;    #not handled
}
sub handlePublicUriAccess {
	my ($self) = @_;
	if ($main::PATH_TRANSLATED =~ /^$main::DOCUMENT_ROOT([^\/]+)(.*)?$/) {
		my ($code, $path) = ($1,$2);
		my $fn = $self->getFileFromCode($code);
		if (! defined $fn) {
			main::printHeaderAndContent(main::getErrorDocument('404 Not Found','text/plain','404 - NOT FOUND'));
			return 1;
		} 	

		$main::DOCUMENT_ROOT = $fn;
		$main::DOCUMENT_ROOT.='/' if $main::DOCUMENT_ROOT !~ /\/$/;
		$main::PATH_TRANSLATED = $fn . $path;		
		$main::VIRTUAL_BASE = $$self{virtualbase}.$code.'/?';
		
		if ($$self{backend}->isDir($main::PATH_TRANSLATED)) {
			$main::PATH_TRANSLATED .= '/' if $main::PATH_TRANSLATED !~ /\/$/;
			$main::REQUEST_URI .= '/' if $main::REQUEST_URI !~ /\/$/;	
		} 
		
		return 0;
	} else {
		main::printHeaderAndContent(main::getErrorDocument('404 Not Found','text/plain','404 - NOT FOUND'));
		return 1;
	}
}

1;