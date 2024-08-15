namespace Searcher
{

[GtkTemplate(ui="/io/github/ydalton/Searcher/ui/window.ui")]
public class Window : Gtk.ApplicationWindow
{
    [GtkChild]
    private unowned Gtk.Entry search_bar;

    private List<DesktopAppInfo> _desktop_file_list;

    private List<DesktopAppInfo> desktop_file_list {
	get {
	    if(_desktop_file_list == null)
		_desktop_file_list = get_desktop_files();
	    return _desktop_file_list;
	}
    }

    private Gtk.TreeModel build_completion()
    {
	Gtk.TreeIter iter;
	var store = new Gtk.ListStore(2, Type.STRING, Type.STRING);

	foreach(var desktop_file in desktop_file_list) {
	    var name = desktop_file.get_string("Name");
	    var exec = desktop_file.get_string("Exec");
	    if(exec == null)
		continue;
	    store.append(out iter);
	    store.set(iter, 0, name, 1, exec, -1);
	}
	
	return store;
    }

    [GtkCallback]
    public bool on_keypress_cb(Gtk.Widget widget, Gdk.EventKey event)
    {
	if(event.keyval == Gdk.Key.Escape) {
	    this.close();
	    return true;
	}
	return false;
    }

    [GtkCallback]
    public bool close_cb()
    {
	this.close();
	return true;
    }

    [GtkCallback]
    public void on_enter_cb()
    {
	var text = search_bar.text;
	string exec;

	// Try to launch an application and close the launcher if
	// successful.
	foreach(var desktop_file in desktop_file_list) {
	    if(desktop_file.get_string("Name").down() == text.down()) {
		// FIXME: sometimes exec string in desktop file contain
		// placeholder strings like %F to signify where a file
		// would go. Ignore those in the future.
		exec = desktop_file.get_string("Exec");

		try {
		    Process.spawn_command_line_async(exec);
		} catch (SpawnError e) {
		    warning("Failed to launch process: %s", e.message);
		    warning("Command-line: %s", exec);
		    return;
		}

		this.close();
	    }
	}

	message("No results found.");
    }

    construct {
	var completion = new Gtk.EntryCompletion();
	completion.model = build_completion();
	completion.text_column = 0;
	this.search_bar.completion = completion;
    }
    
    public Window(Gtk.Application application)
    {
	Object(application: application);
    }
}

} // namespace Searcher
