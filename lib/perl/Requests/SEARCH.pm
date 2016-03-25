########################################################################
# (C) ZE CMS, Humboldt-Universitaet zu Berlin
# Written 2016 by Daniel Rohde <d.rohde@cms.hu-berlin.de>
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
# RFC 5323 ( http://tools.ietf.org/search/rfc5323 )
#
# EXAMPLES:
# Schema Discovery Request:
#  <?xml version="1.0"?>
#  <query-schema-discovery xmlns="DAV:">
#  <basicsearch><from><scope><href>http://recipes.example</href><depth>infinity</depth></scope></from></basicsearch>
#  </query-schema-discovery>
# 
# Search Request:
# <d:searchrequest xmlns:d="DAV:">
# <d:basicsearch>
# <d:select><d:prop><d:getcontentlength/></d:prop></d:select>
# <d:from><d:scope><d:href>/</d:href><d:depth>infinity</d:depth></d:scope></d:from>
# <d:where><d:gt><d:prop><d:getcontentlength/></d:prop><d:literal>10000</d:literal></d:gt></d:where>
# <d:orderby><d:order><d:prop><d:getcontentlength/></d:prop><d:ascending/></d:order></d:orderby>
# </d:basicsearch>
# </d:searchrequest>
#
package Requests::SEARCH;

use strict;
use warnings;

our $VERSION = '2.0';

use base qw( Requests::Request );

use English qw ( -no_match_vars );

use HTTPHelper qw( read_request_body print_header_and_content );
use WebDAV::XMLHelper qw( create_xml simple_xml_parser );

use WebDAV::Search;

sub handle {
    my ( $self, $cgi, $backend ) = @_;

    my $config = main::getConfig();

    my @resps;
    my $status  = '207 Multistatus';
    my $content = q{};
    my $type    = 'application/xml';
    my @errors;

    my $xml     = read_request_body();
    my $xmldata = q{};
    if ( !eval { $xmldata = simple_xml_parser( $xml, 1 ); } ) {
        $self->debug("_SEARCH: invalid XML request: ${EVAL_ERROR}");
        $self->debug("_SEARCH: xml-request=$xml");
        return print_header_and_content('400 Bad Request');
    }
    if ( exists ${$xmldata}{'{DAV:}query-schema-discovery'} ) {
        $self->debug('_SEARCH: found query-schema-discovery');
        WebDAV::Search->new($config)
          ->get_schema_discovery( $main::REQUEST_URI, \@resps );
    }
    elsif ( exists ${$xmldata}{'{DAV:}searchrequest'} ) {
        foreach my $s ( keys %{ ${$xmldata}{'{DAV:}searchrequest'} } ) {
            if ( $s =~ /{DAV:}basicsearch/xms ) {
                WebDAV::Search->new($config)
                  ->handle_basic_search( ${$xmldata}{'{DAV:}searchrequest'}{$s},
                    \@resps, \@errors );
            }
        }
    }
    if ( $#errors >= 0 ) {
        $content = create_xml( { error => \@errors } );
        $status = '409 Conflict';
    }
    elsif ( $#resps >= 0 ) {
        $content = create_xml( { multistatus => { response => \@resps } } );
    }
    else {
        $content = create_xml( { multistatus => {} } )
          ;    ## rfc5323 allows empty multistatus
    }
    $self->debug(
"_SEARCH: status=$status, type=$type, request:\n$xml\n\n response:\n $content\n\n"
    );
    return print_header_and_content( $status, $type, $content );
}

1;