namespace Salty {
	/**
	 * Main entry point
	 *
	 * Session is the main entry point for a Salty implementation. It handles command line arguments and session-specific data
	 *
	 * Session handling is achieved by appending the session ID to the GApplication application_id. This way, a single process model is maintained for each session. In other words: each session has its own process.
	 *
	 * Note that Session derives from Gtk.Application!
	 */
	public class Session : Gtk.Application {
		/**
		 * Session ID
		 */
		public string id { get; protected set; default = "default"; }

		/**
		 * Session base directory
		 *
		 * This is the base directory for all session-related storage. It is usually a directory named {@link id} in the user's HOME/.salty.
		 */
		public string directory { get; protected set; }

		/**
		 * Settings dictionary
		 *
		 * This is typically a Variant dictionary of type {sv} (strings mapped to Variants).
		 *
		 * The settings are usually read from a file, see {@link load_settings}
		 */
		public VariantDict settings { get; protected set; }

		construct {
			/* Set properties */
			flags = ApplicationFlags.HANDLES_COMMAND_LINE;

			/* Add command line options */
			add_main_option("session", 's', 0, OptionArg.STRING, "Specify session ID", "SESSION");
			add_main_option("window", 'w', 0, OptionArg.INT, "Specify window by ID or create new window with -1", "WINDOW");
			add_main_option("", 0, 0, OptionArg.STRING_ARRAY, "", "URI...");

			/* Connect signals */
			handle_local_options.connect(handle_options);
			command_line.connect(handle_command_line);
			startup.connect(load_session);
		}

		/**
		 * Handles command line on the primary instance by connecting to command_line
		 */
		protected int handle_command_line(ApplicationCommandLine command_line) {
			/* Get options */
			var options = command_line.get_options_dict();

			/* Get uris */
			string[] uris = {};
			var _uris = options.lookup_value("", VariantType.STRING_ARRAY);
			if (_uris != null) {
				foreach (var _uri in _uris.get_strv()) {
					var uri = URI.from_input(_uri);
					debug("Parsed URI from command line: " + uri);
					uris += uri;
				}
			}

			/* Choose a window */
			Window? window = null;
			var _window = options.lookup_value("window", VariantType.INT32);
			if (_window == null) {
				/* No ID specified, use active window */
				window = active_window as Window;
			} else {
				/* ID specified, select window */
				window = get_window_by_id(_window.get_int32()) as Window;
			}

			/* If no window has been found so far, create a new one */
			if (window == null) {
				window = new Window();
				add_window(window);

				/* Print window ID */
				command_line.print("Created window with ID: %u\n", window.get_id());
			}

			/* Add views to window */
			foreach (var uri in uris) {
				var view = new WebView();

				/* Add to window */
				window.views.append_page(view, view.tab);

				/* Load URI */
				view.load_uri(uri);

				/* Show it */
				view.show();
			}

			/* If we created a new window, show everything */
			if (!window.visible)
				window.show_all();

			return 0;
		}

		/**
		 * Handles local options by connecting to handle_local_options
		 */
		protected int handle_options(VariantDict options) {
			/* ID */
			var sid = options.lookup_value("session", VariantType.STRING);
			if (sid != null) {
				id = sid.get_string();
			}

			/* Set application ID */
			application_id = application_id + "." + id;
			debug("application_id: " + application_id);

			/* Directory */
			directory = Path.build_filename(Environment.get_home_dir(), ".salty", "session", id);
			return -1;
		}

		/**
		 * Load session
		 *
		 * Loads the session specified by {@link id}: settings, bookmarks etc. and creates the session directory if it doesn't exist.
		 *
		 * This is called automatically at the GApplication startup signal.
		 */
		public void load_session() {
			/* Create directory if necessary */
			try {
				var file = File.new_for_path(directory);
				file.make_directory_with_parents();
			} catch (IOError e) {
				if (!(e is IOError.EXISTS))
					throw e;
			}

			/* Load settings from files */
			load_settings_from_files();
		}

		/**
		 * Load settings from JSON
		 *
		 * Settings provided are shallowly merged over the defaults in {@link Settings.DEFAULT}
		 *
		 * @see Settings.merge_json_objects
		 *
		 * @param json Settings to load in JSON
		 */
		public void load_settings(string json) {
			/* Parse settings */
			var settings_node = Json.from_string(json);
			var settings_obj = settings_node.get_object();
			var defaults_obj = Json.from_string(Settings.DEFAULT).get_object();

			settings_obj = Settings.merge_json_objects(defaults_obj, settings_obj);

			/* Deserialize into Variant dictionary */
			settings = new VariantDict(Json.gvariant_deserialize(settings_node, null));
		}

		/**
		 * Load settings from default JSON files
		 *
		 * Default files are:
		 *
		 *  * .salty/settings.json
		 *  * .salty/sessions/{@link id}/settings.json
		 *
		 * Both will be merged over {@link Settings.DEFAULT}
		 */
		public void load_settings_from_files() {
			string[] jsons = { Settings.DEFAULT };
			string[] files = { Path.build_filename(Environment.get_home_dir(), ".salty", "settings.json"),Path.build_filename(directory, "settings.json") };
			var object = new Json.Object();
			var node = new Json.Node(Json.NodeType.OBJECT);

			/* Load files if they exist */
			foreach (var file in files) {
				try {
					string contents;
					FileUtils.get_contents(file, out contents);
					jsons += contents;
				} catch (FileError e) {
					if (!(e is FileError.NOENT))
						throw e;
				}
			}

			/* Merge JSON objects */
			foreach (var json in jsons)
				Settings.merge_json_objects(object, Json.from_string(json).get_object());

			/* Deserialize into Variant dictionary */
			node.take_object(object);
			settings = new VariantDict(Json.gvariant_deserialize(node, null));
		}
	}
}
