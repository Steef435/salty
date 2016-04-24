#!/usr/bin/gjs

"use strict";

/* Imports */
const GLib = imports.gi.GLib;
const Salty = imports.gi.Salty;
const System = imports.system;

/* Set program name */
GLib.set_prgname("salty");

/* Make sure ARGV is as expected by GApplication and other sane minds */
ARGV.unshift(System.programInvocationName);

/* Create a session */
let ses = new Salty.Session({
	application_id: "io.github.steef435.salty"
});

/* Then run it */
ses.run(ARGV);
