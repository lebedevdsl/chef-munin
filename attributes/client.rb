default['munin']['node']['bind_address']  = node['ipaddress']
default['munin']['node']['port']          = "4949"
default['munin']['node']['ignore_list']   = [".swp"]

default['munin']['logdir'] = "/var/log/munin"
default['munin']['conf_dir'] = "/etc/munin"
default['munin']['rundir'] =   "/var/run/munin"

normal['munin']['node']['munin_master_chef_query'] = "run_list:recipe\\[munin\\:\\:server\\]"
