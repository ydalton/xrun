namespace XRun
{

[GtkTemplate(ui="/io/github/ydalton/XRun/ui/window.ui")]
public class Window : Gtk.ApplicationWindow
{
    [GtkChild]
    private unowned Gtk.Entry search_bar;

    private List<AppInfo> _desktop_file_list;

    private List<AppInfo> desktop_file_list {
	get {
	    if(_desktop_file_list == null)
		_desktop_file_list = AppInfo.get_all();
	    return _desktop_file_list;
	}
    }

    private Gtk.TreeModel build_completion()
    {
	Gtk.TreeIter iter;
	var store = new Gtk.ListStore(2, Type.STRING, Type.STRING);

	foreach(var desktop_file in desktop_file_list) {
	    var name = desktop_file.get_name();
	    store.append(out iter);
	    store.set(iter, 0, name, -1);
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

	// Try to launch an application and close the launcher if
	// successful.
	foreach(var desktop_file in desktop_file_list) {
	    if(desktop_file.get_name().down() == text.down()) {
		var launch_ctx = Gdk.Display.get_default()
		                            .get_app_launch_context();
		try {
		    desktop_file.launch(null, launch_ctx);
		} catch(Error e) {
		    warning("Failed to launch: %s", e.message);
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
	completion.inline_completion = true;
	completion.popup_single_match = false;
	this.search_bar.completion = completion;
    }
    
    public Window(Gtk.Application application)
    {
	Object(application: application);
    }
}

} // namespace XRun
