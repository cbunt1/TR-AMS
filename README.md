Tomato Router Automated Maintenance System

OK, so it's just a catchy acronym, and I'll probably change it.

The general idea here is that I want to remotely backup and store offline copies of my Tomato router configurations. We'll create and manage them with the setup scripting tool's 'export' option.

Once the configuration script is backed up and stored, we'll pull them down to an offline repository.

The core utility will be a relatively simple script that just does what needs to be done to make the backup. This part runs on the router being backed up (the client)

The host/server end will invoke the backup process, and then pull the backed-up file down.

Conceptually it's similar to a number of enterprise-level backup schemes I've seen put in play.

I will eventually publish it, but for now it's in a development mode. Should you wish to play with it, have at it, but the only thing I'll promise you is that it's got some code. :)
