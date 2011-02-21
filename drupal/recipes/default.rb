#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: drupal
# Recipe:: default
#
# Copyright 2010, Promet Solutions
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

include_recipe "apache2"
include_recipe %w{php::php5 php::module_mysql}
include_recipe "mysql::server"
Gem.clear_paths
require 'mysql'

mysql_database node[:drupal][:db][:database]
mysql_grant "mysql-install-drupal-privileges" do
  database node[:drupal][:db][:database]
  user node[:drupal][:db][:user]
  password node[:drupal][:db][:password]
end

#install drupal
drupal_source "#{node[:drupal][:dir]}" do
  version "#{node[:drupal][:version]}"
end

if node.has_key?("ec2")
  server_fqdn = node.ec2.public_hostname
else
  server_fqdn = node.fqdn
end

log "Navigate to 'http://#{server_fqdn}/install.php' to complete the drupal installation" do
  action :nothing
end

template "#{node[:drupal][:dir]}/sites/default/settings.php" do
  source "settings.php.erb"
  mode "0644"
  variables(
    :database        => node[:drupal][:db][:database],
    :user            => node[:drupal][:db][:user],
    :password        => node[:drupal][:db][:password]
  )
  notifies :write, resources(:log => "Navigate to 'http://#{server_fqdn}/install.php' to complete the drupal installation")
end

web_app "drupal" do
  template "drupal.conf.erb"
  docroot "#{node[:drupal][:dir]}"
  server_name server_fqdn
  server_aliases node.fqdn
end

include_recipe "drupal::cron"
