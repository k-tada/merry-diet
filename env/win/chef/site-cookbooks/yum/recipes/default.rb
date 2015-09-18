#
# Cookbook Name:: yum
# Recipe:: default
#
# Copyright 2015, k.t
#
# All rights reserved - Do Not Redistribute
#

yum_package 'yum-fastestmirror' do
  action :install
end

execute 'yum update' do
  user "root"
  command "yum update -y"
  action :run
end
