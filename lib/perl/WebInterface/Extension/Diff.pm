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
# diff - sets the path to GNU diff (default: /usr/bin/diff)
# disable_fileactionpopup - disables fileaction entry in popup menu
# enable_apps - enables sidebar menu entry
# files_only - disables folder comparision (neccassary for none-local filesystem backends like SMB, DB) 
# 

package WebInterface::Extension::Diff;

use strict;

use WebInterface::Extension;
our @ISA = qw( WebInterface::Extension  );

use JSON;
sub init { 
	my($self, $hookreg) = @_; 
	my @hooks = ('css','locales','javascript', 'posthandler');
	push @hooks,'fileactionpopup' unless $main::EXTENSION_CONFIG{Diff}{disable_fileactionpopup};
	push @hooks,'apps' if $main::EXTENSION_CONFIG{Diff}{enable_apps};
	$hookreg->register(\@hooks, $self);
}

sub handle { 
	my ($self, $hook, $config, $params) = @_;
	my $ret = $self->SUPER::handle($hook, $config, $params);
	return $ret if $ret;
	if ($hook eq 'fileactionpopup') {
		$ret ={ action=>'diff', label=>'diff', path=>$$params{path}, type=>'li'};	
	} elsif ($hook eq 'apps') {
		$ret = $self->handleAppsHook($$self{cgi},'listaction diff sel-oneormore disabled','diff_short','diff'); 
	} elsif ($hook eq 'posthandler' && $$self{cgi}->param('action') eq 'diff') {
		my %jsondata  = ();
		my ($content, $raw);
		my @files = $$self{cgi}->param('files');
		if (scalar(@files)==2) { 
			($content,$raw) = $self->renderDiffOutput(@files) if $self->checkFilesOnly(@files);
		}
		if (!$content) {
			if (scalar(@files)!= 2) {
				$jsondata{error} = $self->tl('diff_msg_selecttwo');
			} else {
				$jsondata{error} = sprintf($self->tl('diff_msg_differror'),$$self{cgi}->param('files'));
			}
			
		} else {
			$jsondata{content} = $content;
			$jsondata{raw} = $raw;
		}
		my $json = new JSON();
		main::printCompressedHeaderAndContent('200 OK', 'application/json', $json->encode(\%jsondata), 'Cache-Control: no-cache, no-store');
		
		$ret=1;
	}
	return $ret;
}
sub checkFilesOnly {
	my $self = shift @_;
	return 1 unless $self->config('files_only',0);
	while (my $f = shift @_) {
		return 0 unless $$self{backend}->isFile($main::PATH_TRANSLATED.$f);
	} 
	return 1;
}
sub substBasepath {
	my($self,$f) = @_;
	$f=$$self{backend}->resolveVirt($f);
	$f=~s/^\Q$main::PATH_TRANSLATED\E//;
	return $f;
}
sub renderDiffOutput {
	my ($self,@files) = @_;
	my $ret = 0;
	my $cgi = $$self{cgi};
	my ($f1,$f2) = @files;
	my $raw = ""; 
	if (open(DIFF, '-|', $self->config('diff','/usr/bin/diff'), '-ru',$$self{backend}->getLocalFilename($main::PATH_TRANSLATED.$f1),$$self{backend}->getLocalFilename($main::PATH_TRANSLATED.$f2))) {
		my $t = $cgi->start_table({-class=>'diff table'});
		my ($lr,$ll) = (0,0);
		$t.=$cgi->Tr({-class=>'diff filename'},$cgi->td({-class=>'diff line'},'#').$cgi->td({-class=>'diff filename'},$f1).$cgi->td({-class=>'diff line'},'#').$cgi->td({-class=>'diff filename'},$f2));
		my $diffcounter = 0;		
		while (<DIFF>) {
			$raw.=$_;
			chomp;
			if (/^-{3}\s+(.*?)\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+ ([\+\-]\d+)$/) {
				my $f = $self->substBasepath($1);
				$t.='<tr class="diff filename">'.$cgi->td({-colspan=>2,-class=>'diff filename'},$f) unless $f =~/^\s*\Q$f1\E\s*$/ || $f=~/^\/tmp\//;
				next;
			} elsif (/^\+{3}\s+(.*?)\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+ ([\+\-]\d+)$/) {
				my $f = $self->substBasepath($1);
				$t.=$cgi->td({-colspan=>2,-class=>'diff filename'},$f).'</tr>'  unless $f=~/^\s*\Q$f2\E\s*$/ || $f =~/^\/tmp\//;
				next;
			} elsif (/^diff /) {
				next;
			} elsif (/^@@ -(\d+)(,(\d+))? \+(\d+)(,(\d+))? @@/) {
				($ll,$lr) = ($1,$4);
				next;
			}
			
			my $o =$_;
			$o=~s/^.//;
			$o=$cgi->div({-class=>'diff pre'},$cgi->escapeHTML($o));
			if (/^\+/) {
				$t.=$cgi->Tr({-class=>'diff added'}, $cgi->td({-class=>'diff line'},"").$cgi->td({-class>='diff added'},"").$cgi->td({-class=>'diff line'},$lr).$cgi->td({-class=>'diff added'},$o));
				$lr++; 
				$diffcounter++;
			} elsif (/^-/) {
				$t.=$cgi->Tr({-class=>'diff removed'},$cgi->td({-class=>'diff line'},$ll).$cgi->td({-class=>'diff removed'},$o).$cgi->td({-class=>'diff line'},"").$cgi->td({-class=>'diff removed'},""));
				$ll++;
				$diffcounter++;
			} elsif (/^ /) {
				$t.=$cgi->Tr({-class=>'diff unchanged'},$cgi->td({-class=>'diff line'},$ll).$cgi->td({-class=>'diff unchanged'},$o).$cgi->td({-class=>'diff line'},$lr).$cgi->td({-class=>'diff unchanged'},$o));
				$ll++; $lr++;
			} elsif (/^Binary files (.*?) and (.*?) differ/) {
				my ($ff1,$ff2) = $self->config('files_only',0) ?($f1,$f2): ($1,$2);
				$t.=$cgi->Tr({-class=>'diff binary'},$cgi->td({-class=>'diff binary',-colspan=>4}, sprintf($self->tl('diff_binary'),$self->substBasepath($ff1),$self->substBasepath($ff2))));
				$diffcounter++;
			} elsif (/^Only in (.*?): (.*)$/) {
				$t.=$cgi->Tr({-class=>'diff onlyin'},$cgi->td({-class=>'diff onlyin',-colspan=>4}, sprintf($self->tl('diff_onlyin'),$self->substBasepath($1),$self->substBasepath($2))));
				$diffcounter++;
			} elsif (/^\\\s*No newline at end of file/i) {
				$t.=$cgi->Tr({-class=>'diff comment'},$cgi->td({-class=>'diff comment',-colspan=>4}, $self->tl('diff_nonewline')));
			} elsif (/^\\ (.*)/ || /^(\w+.*)/) {
				$t.=$cgi->Tr({-class=>'diff comment'},$cgi->td({-class=>'diff comment',-colspan=>4}, $cgi->pre({-class=>'diff pre'},$1)));
			}
		}
		$t.=$cgi->Tr({-class=>'diff comment'}, $cgi->td({-class=>'diff comment',colspan=>4},sprintf($self->tl('diff_nomorediffs'),$diffcounter)));
		$t.=$cgi->end_table();
		$t.=$cgi->div({-class=>'diff raw'},$self->tl('diff_showrawdiff'));
		my $swap =$cgi->div({-class=>'diff swapfiles', -data_file1=>$f1, -data_file2=>$f2},$self->tl('diff_swapfiles'));
		$t.=$swap;
		$ret = $cgi->div({-title=>$self->tl('diff'),-class=>'diff dialog'}, $t);
		
		$raw = 	$$self{cgi}->pre($$self{cgi}->escapeHTML($raw)).$$self{cgi}->div({-class=>'diff formatted'},$self->tl('diff_showdiff')).$swap;
		close(DIFF)
	} 
	return ($ret,$raw);
}
1;