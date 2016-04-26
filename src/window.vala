namespace Salty {
	/**
	 * Browser window
	 *
	 * A browser window contains one or more Views in a tabbed layout. Only one View is visible at a time.
	 * The top of the window shows the tabs (a list of the contained Views).
	 * The middle of the window contains a View.
	 * The bottom of the window contains a bar for status messages.
	 */
	public class Window : Gtk.ApplicationWindow {
		/* TODO: Bar */

		/**
		 * Main layout grid
		 */
		public Gtk.Grid grid { get; protected set; }

		/**
		 * Notebook containing Views
		 */
		public Gtk.Notebook views { get; protected set; }

		construct {
			/* Create widgets */
			grid = new Gtk.Grid();
			grid.orientation = Gtk.Orientation.VERTICAL;

			views = new Gtk.Notebook();
			views.expand = true;

			/* Add widgets */
			grid.add(views);

			add(grid);
		}
	}
}
