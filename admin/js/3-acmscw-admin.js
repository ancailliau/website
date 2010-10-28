function open_dataset(url, label) {
	tabs = $("#admin-tabs");
	tabs.tabs('add', '/dba/' + url, label);
	tabs.tabs('select', tabs.tabs('length')-1);
	$("#admin-tabs table").fixedHeaderTable();
}