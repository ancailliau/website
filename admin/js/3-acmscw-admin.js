function open_tab(url, label) {
	tabs = $("#admin-tabs");
	found = false;
	for (i=0; i<tabs.tabs("length"); i++){
		if ($("#admin-tabs li:eq(" + i + ") a").html() == label) {
    	tabs.tabs('select', i);
      found = true;
			break;
		}
	}
	if (!found) {
		tabs.tabs('add', url + "?jsrequest=true", label);
		tabs.tabs('select', tabs.tabs('length')-1);
	}
}