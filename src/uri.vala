/**
 * URI utilities
 */
namespace Salty.URI {
	/**
	 * Parse user-generated string as URI
	 *
	 * The URI is generated as follows, ordered by decreasing importance:
	 *
	 *  * If the input has a scheme, it will be returned as-is.
	 *  * If  a file with this name exists, a URI to this file will be returned.
	 *  * If the input contains at least one dot, the input will be returned with an http scheme.
	 *  * A URI to a search engine (duckduckgo) with input as query will be returned.
	 *
	 * @param input User input to be parsed
	 * @return Parsed URI
	 */
	public string from_input(string input) {
		/* Has scheme */
		if (Uri.parse_scheme(input) != null)
			return input;

		/* Is file */
		var file = File.new_for_commandline_arg(input);
		if (file.query_exists(null))
			return file.get_uri();

		/* If dot, assume http */
		if (input.contains("."))
			return "http://" + /^\/*/.replace(input, -1, 0, "");

		/* Search engine */
		return "https://duckduckgo.com/?q=" + Uri.escape_string(input);
	}
}
