#
# Cookbook Name:: munin
# Recipe:: server.rb
#
# Copyright 2013, Cloudgate-Service Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "munin::client"

# Requirement definitions for different platforms
# TBD

# Autodetecting nodes
if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  monitored_nodes = search(:node, node['munin']['master']['munin_node_chef_query'])
end

if monitored_nodes.empty?
  Chef::Log.info("No nodes returned from search, using this node so munin configuration has data")
  monitored_nodes = Array.new
  monitored_nodes << node
end

# Installing master package from squeeze-backports
package "munin" do
  options "-t squeeze-backports"
  version "2.0.6-3~bpo60+1"
end

# Enable support for rrdcached
package "rrdcached"

# Installing dependency for munin cgi-graph and cgi-html
package "spawn-fcgi" do
  only_if {node['munin']['master']['graph_strategy'] or node['munin']['master']['html_strategy'] == "cgi"}
end

# Spawning rrdcached
template  "/etc/default/rrdcached" do
  source  "rrdcached-defaults.erb"
  owner   "root"
  group   "root"
end

service "rrdcached" do
  supports  :start => true, :stop => true
  action    [:enable, :start]
end

# Fixing permissions to rrdcached socket
execute "setfacl" do
  command "setfacl -Rm u:munin:rwx,d:u:munin:rwx #{node['munin']['rundir']}"
end

# Deploying configuration for munin-master
template "#{node['munin']['conf_dir']}/munin.conf" do
  source  "munin.conf.erb"
  owner   "root"
  group   "root"
  variables(:monitored_nodes => monitored_nodes)
end

# Create web directory
directory node['munin']['master']['htmldir'] do 
  owner   "www-data"
  group   "www-data"
end

# Starting cgi-graph
template "/etc/init.d/spawn-fcgi-munin-graph" do
  source  "fcgi-graph.erb"
  owner   "root"
  group   "root"
  mode    "0700"
  only_if {node['munin']['master']['graph_strategy'] == "cgi"}
end

service "spawn-fcgi-munin-graph" do
  pattern "munin-cgi-graph"
  supports  :start => true, :stop => true, :restart => true
  action    [:enable, :start]
  only_if {node['munin']['master']['graph_strategy'] == "cgi"}
end 

# Starting cgi-html
template "/etc/init.d/spawn-fcgi-munin-html" do
  source  "fcgi-html.erb"
  owner   "root"
  group   "root"
  mode    "0700"
  only_if {node['munin']['master']['html_strategy'] == "cgi"}
end

service "spawn-fcgi-munin-html" do
  pattern "munin-cgi-html"
  supports  :start => true, :stop => true, :restart => true
  action    [:enable, :start]
  only_if {node['munin']['master']['html_strategy'] == "cgi"}
end 

# Create empty htpasswd file in docroot
file "#{node['munin']['master']['htmldir']}/.htpasswd" do
  action    :create_if_missing
end

# Add nginx VH configuration file if necessary
template "/etc/nginx/sites-available/munin-master.conf" do
  source "nginx.conf.erb"
  only_if {node['nginx']}
end

link "/etc/nginx/sites-enabled/munin-master.conf" do
  to "/etc/nginx/sites-available/munin-master.conf"
  only_if {node['nginx']}
end