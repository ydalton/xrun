namespace Searcher
{

[GtkTemplate(ui="/io/github/ydalton/Searcher/ui/window.ui")]
public class Window : Gtk.ApplicationWindow
{
    [GtkChild]
    private unowned Gtk.Entry search_bar;

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
	message("%s", search_bar.text);
    }
    
    public Window(Gtk.Application application)
    {
	Object(application: application);
    }
}

} // namespace Searcher
