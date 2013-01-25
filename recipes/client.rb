#
# Cookbook Name:: munin
# Recipe:: client
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

# Autodetecting master for a node
if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  munin_masters = search(:node, node['munin']['node']['munin_master_chef_query'])
end

if munin_masters.empty?
  Chef::Log.info("No nodes returned from search, using this node so munin configuration has data")
  munin_masters = Array.new
  munin_masters << node
end

# Installing required package
package "munin-node" do
  options "-t squeeze-backports"
  version "2.0.6-3~bpo60+1"
end


# Deploying node configuration
template  "#{node['munin']['conf_dir']}/munin-node.conf" do
  source  "munin-node.conf.erb"
  owner   "root"
  group   "root"
  variables(:munin_masters => munin_masters)
end

# Starting node daemon
service "munin-node" do
  supports  :start => true, :stop => true, :restart => true
  action    :start
end

