namespace Salty {
	/**
	 * Tab widget for a WebView
	 *
	 * Displays info about the webview, and updates by connecting to appropriate signals. To be used as a tab widget for Gtk.Notebook.
	 *
	 * @see WebView.tab
	 */
	public class WebViewTabWidget : Gtk.Grid {
		/**
		 * WebView to extract data from
		 */
		public weak WebView view { get; construct; default = null; }

		/**
		 * Favicon image
		 */
		public Gtk.Image favicon { get; protected set; }

		/**
		 * Title label
		 */
		public Gtk.Label title { get; protected set; }

		construct {
			orientation = Gtk.Orientation.HORIZONTAL;

			/* Title */
			title = new Gtk.Label(null);
			title.expand = true;

			/* Add widgets */
			add(title);

			/* Show widgets */
			title.show();

			/* Handle view */
			if (view != null) {
				/* Set initial values */
				update_title();

				/* Keep up to date */
				view.notify["title"].connect(() => {
					update_title();
				});
			} else {
				warning("Creating a TabWidget without WebView leads to a useless TabWidget");
			}
		}

		/**
		 * Create a TabWidget
		 */
		public WebViewTabWidget(WebView view) {
			Object(view: view);
		}

		/**
		 * Update {@link title}
		 */
		protected void update_title() {
			title.label = view.title;
		}
	}
}
