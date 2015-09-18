# -*- coding: utf-8 -*-
#
# Cookbook Name:: vim
# Recipe:: default
#
# Copyright 2015, k.t
#
# All rights reserved - Do Not Redistribute
#

# Requires
%w[
  tar
  gcc
  make
  libffi-devel
  zlib-devel
  openssl-devel
  readline-devel
  sqlite-devel
].each do |p|
  package "#{p}" do
    action :install
  end
end

# clone rbenv
git "/usr/local/rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  action :checkout
  reference "master"
  user "root"
  group "root"
  not_if "ls -l /usr/local/ | grep rbenv"
end

# create rbenv initialization script
template "/etc/profile.d/rbenv.sh" do
  owner "root"
  group "root"
  mode 0644
  not_if "ls -l /etc/profile.d/ | grep rbenv"
end

# create plugin directory 
directory "/usr/local/rbenv/plugins" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# clone ruby-build
git "/usr/local/rbenv/plugins/ruby-build" do
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :checkout
  user "root"
  group "root"
  not_if "ls -l /usr/local/rbenv/plugins/ | grep ruby-build"
end

execute "chgrp" do
  command "chgrp -R vagrant /usr/local/rbenv"
  user "root"
  group "root"
  action :run
end

execute "chmod" do
  command "chmod -R g+rwxXs /usr/local/rbenv"
  user "root"
  group "root"
  action :run
end

# install ruby
["2.2.2"].each do |v|
  execute "install ruby #{v}" do
    not_if "source /etc/profile.d/rbenv.sh; rbenv versions | grep #{v}"
    command "source /etc/profile.d/rbenv.sh; rbenv install #{v}"
    user "vagrant"
    group "vagrant"
    action :run
  end
end

# set global
["2.2.2"].each do |v|
  execute "set global ruby" do
    not_if "source /etc/profile.d/rbenv.sh; rbenv global | grep #{v}"
    command "source /etc/profile.d/rbenv.sh; rbenv global #{v}; rbenv rehash"
    user "vagrant"
    group "vagrant"
    action :run
  end
end

