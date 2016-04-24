/**
 * Test Salty.URI.from_input
 */

const Salty = imports.gi.Salty;

if (Salty.uri_from_input("abc://foo") != "abc://foo")
	throw new Error("Failed scheme parsing");

if (Salty.uri_from_input("uri_from_input.js").match(/^file:\/\/.*uri_from_input\.js$/) == null)
	throw new Error("Failed file parsing");

if (Salty.uri_from_input("example.com") != "http://example.com")
	throw new Error("Failed dot parsing");

if (Salty.uri_from_input("porn and memes") != "https://duckduckgo.com/?q=porn%20and%20memes")
	throw new Error("Failed search engine");
