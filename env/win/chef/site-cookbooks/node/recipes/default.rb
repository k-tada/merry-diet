# -*- coding: utf-8 -*-
#
# Cookbook Name:: node
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Requires
%w[
  wget
].each do |p|
  package "#{p}" do
    action :install
  end
end


# download nodebrew
execute "wget git.io/nodebrew" do
  cwd "/tmp"
  command "wget git.io/nodebrew"
  user "vagrant"
  not_if "ls -l ~/ | grep nodebrew"
end

# install nodebrew
execute "perl nodebrew setup" do
  environment "NODEBREW_ROOT" => "/home/vagrant/.nodebrew"
  cwd "/tmp"
  command "perl nodebrew setup"
  user "vagrant"
  not_if "ls -sla ~/ | grep .nodebrew"
end

install_node_version = 'stable'

# install node
bash "install node" do
  user "vagrant"
  group "vagrant"
  environment(
    "NODEBREW_ROOT" => "/home/vagrant/.nodebrew",
    "PATH" => "/home/vagrant/.nodebrew/current/bin:#{ENV["PATH"]}"
  )
  code <<-SCRIPT
    nodebrew install-binary #{install_node_version}
    nodebrew use #{install_node_version}
  SCRIPT
  not_if "which node"
end

# nodebrew setting
file "/home/vagrant/.bashrc" do
  user "vagrant"
  group "vagrant"
  content <<-SCRIPT
    # .bashrc

    # Source global definitions
    if [ -f /etc/bashrc ]; then
            . /etc/bashrc
    fi

    alias nb='nodebrew'
    # nodebrew default
    export PATH=$HOME/.nodebrew/current/bin:$PATH
    nodebrew use #{install_node_version}
  SCRIPT
  not_if "which node"
end


