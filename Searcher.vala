namespace Searcher
{

class Application : Gtk.Application
{
    public Application()
    {
	Object(application_id: "io.github.ydalton.Searcher",
	       flags: ApplicationFlags.DEFAULT_FLAGS);
    }

    public override void activate()
    {
	var window = new Window(this);
	window.present();
    }
    
    public static int main(string[] args)
    {
	var application = new Searcher.Application();
	return application.run();
    }
}

} // namespace Searcher
