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
	    if(should_match(desktop_file.get_name(), text)) {
                var launch_ctx = Gdk.Display.get_default()
                                            .get_app_launch_context();
                try {
                    desktop_file.launch(null, launch_ctx);
                } catch(Error e) {
                    warning("Failed to launch: %s", e.message);
                    return;
                }

                this.close();

                return;
            }
        }

        message("No results found.");
    }

    private bool should_match(string name, string key)
    {
        if(key.down() in name.down())
            return true;

        return false;
    }

    private bool match_func(Gtk.EntryCompletion completion,
                            string key,
                            Gtk.TreeIter iter)
    {
        Value text_value;

        var model = completion.model;
        model.get_value(iter, completion.text_column, out text_value);
        var row = text_value.get_string();

	return should_match(row, key);
    }

    construct {
        var completion = new Gtk.EntryCompletion() {
            model = build_completion(),
            text_column = 0,
            inline_completion = true,
            popup_single_match = true,
        };
        completion.set_match_func(match_func);
        this.search_bar.completion = completion;
    }

    public Window(Gtk.Application application)
    {
        Object(application: application);
    }
}

} // namespace XRun
