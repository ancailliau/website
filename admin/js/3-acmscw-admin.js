function open_tab(url, label) {
	tabs = $("#admin-tabs");
	tabs.tabs('add', url + "?jsrequest=true", label);
	tabs.tabs('select', tabs.tabs('length')-1);
	$("#admin-tabs table").fixedHeaderTable();
}