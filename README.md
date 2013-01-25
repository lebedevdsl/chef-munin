Description
===========

Opscode Chef recipe to install/configure munin-master or nodes.

Requirements
============

All external dependencies installed during first chef-run:
 
*	`rrdcache` - Support for rrdcached
 
*	`spawn-fcgi` - Dependency for munin cgi-graph and cgi-html

This recipe uses nginx as a web-server.
Other http-daemons are not supported yet.
You must enable debian-backports repository to get munin 2.0

Platforms
---------

* `Debian >= 6`

Attributes
==========

Generic
-------

* `default['munin']['conf_dir']` - /etc/munin Debian-style

You can change default directory values as they appear in munin configuration file: 

* `default['munin']['logdir']`
* `default['munin']['rundir']`

Master
------

* `normal['munin']['server']['munin_node_chef_query']` - Query to compose list of monitored nodes

You can change default directory values as they appear in munin configuration file:

* `default['munin']['master']['dbdir']`
* `default['munin']['master']['htmldir']`
* `default['munin']['master']['tmpldir']`
* `default['munin']['master']['staticdir']`
* `default['munin']['master']['cgitmpdir']`

Other configuration options appear like in munin.conf

* `normal['munin']['master']['graph_period']` - You can choose the time reference for graphs, and show per "minute", "hour" instead of the default "second"
* `normal['munin']['master']['munin_cgi_graph_jobs']` - munin-cgi-graph is invoked by the web server up to very many times at the same time. Defaults to 6
* `normal['munin']['master']['max_processes']` - munin-update runs in parallel. The default max number of processes is 16, and is probably ok for you.

Other configuration options:

* `normal['munin']['master']['server_name']` - Server name for nginx VirtualHost
* `normal['munin']['master']['port']` - Listen port for nginx VirtualHost
* `normal['munin']['master']['contact_list']` - Is a hash of contacts. {"alias" => "email"}. Alias is a single word (without spaces).

Node
----

* `normal['munin']['node']['munin_master_chef_query']` - Query to detect a certain master for a node
* `normal['munin']['node']['bind_address']`	- Bind address for munin-node daemon
* `normal['munin']['node']['port']` - Listen port for munin-node daemon
* `normal['munin']['node']['ignore_list']` - Array containing multiple regexes

Usage
=====

