/*********************************************************************
(C) ZE CMS, Humboldt-Universitaet zu Berlin
Written by Daniel Rohde <d.rohde@cms.hu-berlin.de>
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
	var tn = 'savesettings.timeout';
	function saveSettingsRequest() {
		$.MyPost(window.location.pathname,{action:'savesettings'}, function(response) {
			ToolBox.handleJSONResponse(response);
		},true);
	}
	function saveSettings() {
		var body = $("body");
		window.clearTimeout(body.data(tn));
		body.data(tn, window.setTimeout(saveSettingsRequest, 2000));
		
	}
	function deleteSettingsRequest() {
		$.MyPost(window.location.pathname, {action:'deletesettings'}, function(response) {
			ToolBox.handleJSONResponse(response);
		}, true);
	}
	function deleteSettings() {
		var body = $("body");
		window.clearTimeout(body.data(tn));
		body.data(tn, window.setTimeout(deleteSettingsRequest, 2000));
	}
	$("body").on("settingchanged", function(event,data) {
		var self = $(this);
		
		if (data.setting == 'settings.savesettings' && data.value == "savesettings.dontsave") {
			deleteSettings();
		}
		else if ($.MyCookie('settings.savesettings') != "savesettings.dontsave") {
			saveSettings();
		}
	});
	$("#flt").on("bookmarksChanged", function() {
		if ($.MyCookie('settings.savesettings').match(/savesettings\.(savebookmarksonly|saveall)/)) {
			saveSettings();
		}
	});

});