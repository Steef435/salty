namespace Salty {
	/**
	 * Interface for {@link Window} views
	 */
	public interface View : Gtk.Widget {
		/**
		 * Tab widget
		 *
		 * Usually displayed in {@link Window.views}.
		 */
		public abstract Gtk.Widget tab { get; protected set; }
	}
}
