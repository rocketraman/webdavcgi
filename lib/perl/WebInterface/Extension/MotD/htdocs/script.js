/*********************************************************************
(C) ZE CMS, Humboldt-Universitaet zu Berlin
Written 2016 by Daniel Rohde <d.rohde@cms.hu-berlin.de>
**********************************************************************
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
**********************************************************************/
$(document).ready(function() {
	pullMotD();
	showMessage(ToolBox.cookie("motd"), ToolBox.cookie("motdtitle"));
	
	$(".motd").off(".motd").on("click.motd", function(ev) { 
			$.MyPreventDefault(ev); 
			showMessageDialog(ToolBox.cookie("motd"), ToolBox.cookie("motdtitle"));
		}
	);
	$(".action.showmotd").off(".motd").on("click.motd", function(ev) {
		$.MyPreventDefault(ev);
		showMessageDialog(ToolBox.cookie("motd"), ToolBox.cookie("motdtitle"));
	});
	
	function showMessage(motd,title) {
		var s = $(".motd");
		if (!motd) { 
			s.hide(); 
			motd = "";
		} else {
			s.show();
		}
		s.html(title||motd).attr("title", motd).data("htmltooltip",motd).MyTooltip(0);

		$(".action.showmotd").show().data("htmltooltip", motd);

		return;
	}
	function showMessageDialog(motd,title) {
		if (!motd) return;
		$("<div/>").attr("class","motd-content").html(motd)
		.dialog({
			modal:true,width:"auto",height:"auto", 
			dialogClass: "motd-dialog", 
			title: title || 'Message Of The Day [MOTD]', close: function(){}}).show();
		return;
	}
	function showMotD(motd) {
		var message = motd.message;
		var digest = motd.digest;
		var pullinterval = motd.pullinterval * 1000;
		
		if (pullinterval > 0) window.setTimeout(pullMotD, pullinterval);
		
		if (!message) {
			ToolBox.rmcookies("motd","motdtstamp","motdtitle");
			showMessage();
			$(".action.showmotd").hide();
			return;
		}

		// can be LANG specific:
		ToolBox.cookie("motdtitle", motd.title); 
		showMessage(message, motd.title);
		
		// guard for message dialog:
		if (ToolBox.cookie("motddigest") == digest) return;
		
		ToolBox.cookie("motddigest", digest, message.session == 0);
		ToolBox.cookie("motd", message, message.session == 0);
		
		showMessageDialog(message, motd.title);
	
		return;
	}
	function pullMotD() {
		$.MyPost(window.location.href, { action : 'motd' }, function(motd) {
				if (motd.error) {
					ToolBox.handleJSONResponse(motd);
				} else {
					showMotD(motd);
				}
		}, true);
		return;
	}
});