default['munin']['nginx_filenames'] = "munin-master.conf"
default['munin']['logdir']          = "/var/log/munin"
default['munin']['conf_dir']        = "/etc/munin"
default['munin']['rundir']          = "/var/run/munin"
default['munin']['master']['munin_node_chef_query'] = "munin:[* TO *]"
default['munin']['master']['dbdir']                 = "/var/lib/munin/"
default['munin']['master']['htmldir']               = "/var/www/virtual-hosts/munin"
default['munin']['master']['tmpldir']               = "/etc/munin/templates"
default['munin']['master']['staticdir']             = "#{node['munin']['conf_dir']}/static"
default['munin']['master']['cgitmpdir']             = "/var/lib/munin/cgi-tmp"
default['munin']['master']['html_strategy']         = "cron"
default['munin']['master']['graph_strategy']        = "cgi"

normal['munin']['master']['server_name']            = node['fqdn']
normal['munin']['master']['graph_period']           = "second"
normal['munin']['master']['munin_cgi_graph_jobs']   = 6
normal['munin']['master']['contact_list']           = {}
normal['munin']['master']['max_processes']          = 6

