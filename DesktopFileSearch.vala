namespace Searcher
{

List<DesktopAppInfo>? get_desktop_files()
{
    var list = new List<DesktopAppInfo>();

    Dir dir;

    // for now it's hardcoded...
    string desktop_file_location = "/usr/share/applications";

    try {
	dir = Dir.open(desktop_file_location);

    } catch(FileError e) {
	warning("%s", e.message);
	return null;
    }

    string? name = null;
    // FIXME: does not handle folders which may contain desktop files
    while((name = dir.read_name()) != null) {
	var fullpath = "%s/%s".printf(desktop_file_location, name);
	if(!FileUtils.test(fullpath, FileTest.IS_REGULAR))
	    continue;

	var app_info = new DesktopAppInfo.from_filename(fullpath);

	if(app_info == null) {
	    warning("%s does not appear to be a valid desktop file", name);
	    continue;
	} else if(app_info.get_string("Type") != "Application") {
	    continue;
	}

	// message("%s %s", app_info.get_string("Name"), app_info.filename);
	list.append(app_info);
    }

    return list;
}

} // namespace Searcher
