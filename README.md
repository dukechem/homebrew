Homebrew
========
Features, usage and installation instructions are [summarized on the homepage][home].

The only reason I forked this, so far, is to add a launchd plist to the smartmontools.rb formula.
I've tested on 10.6, 10.7, 10.8, and 10.9. And "brew services restart smartmontools" starts/stops "smartd -n" ok.

I'll add a new package shortly, similar to debian "smart-notifier" to pop-up warnings for desktop-user.
It adds a plugin shell-script calling either growlnotifier (10.5-10.7)
or terminal-notifier (10.8+, avail from growl). Betas are working with shell scripts in 
/usr/local/etc/smartd_warning.d/ folder (see man smartd.conf about the experimental -m @plugin in smartd.conf).

We now return you to the regularly forked program... ;-)

What Packages Are Available?
----------------------------
1. You can [browse the Formula directory on GitHub][formula].
2. Or type `brew search` for a list.
3. Or run `brew server` to browse packages off of a local web server.
4. Or visit [braumeister.org][braumeister] to browse packages online.

More Documentation
------------------
`brew help` or `man brew` or check our [wiki][].

Who Are You?
------------
I'm Bill Day and I'm a also splendid chap.

License
-------
Code is under the [BSD 2 Clause (NetBSD) license][license].

[home]:http://brew.sh
[wiki]:http://wiki.github.com/mxcl/homebrew
[mxcl]:http://twitter.com/mxcl
[formula]:http://github.com/mxcl/homebrew/tree/master/Library/Formula/
[braumeister]:http://braumeister.org
[license]:https://github.com/mxcl/homebrew/tree/master/Library/Homebrew/LICENSE
