namespace Salty {
	/**
	 * {@link View} for displaying web pages
	 *
	 * Subclass of WebKit.WebView for possible future extensions
	 */
	public class WebView : WebKit.WebView, View {
		/**
		 * Tab widget showing favicon and title
		 */
		public Gtk.Widget tab { get; protected set; }

		construct {
			tab = new WebViewTabWidget(this);

			/* Show tab when this is shown */
			show.connect(() => {
				tab.show();
			});
		}
	}
}
