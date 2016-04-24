namespace Salty.Settings {
	/**
	 * Default settings (JSON)
	 *
	 * Default settings which can be overridden.
	 * @see Session.load_settings
	 */
	public const string DEFAULT = """
	{
		"bookmarks": "bookmarks",
		"WebKitSettings": {
			"enable-developer-extras": true
		}
	}
	""";

	/**
	 * Shallowly merge two JSON objects
	 *
	 * The members from the second parameter will be merged down on the first parameters. When two members conflict, those from the second parameter will overwrite the ones from the first.
	 *
	 * This method is shallow, meaning that Object members will not be merged as well, if both objects have an object member with the same name, the object from top_obj will be merged down as a whole, replacing the object in base_obj.
	 *
	 * @param base_obj The base object. Members in this object are recessive.
	 * @param top_obj The object from which members will be merged into base_obj. Members are dominant.
	 * @return A reference to base_obj, now merged.
	 */
	public Json.Object merge_json_objects(Json.Object base_obj, Json.Object top_obj) {
		foreach (string member in top_obj.get_members())
			base_obj.set_member(member, top_obj.dup_member(member));

		return base_obj;
	}
}
