# -*- coding: utf-8 -*-
#
# Cookbook Name:: git
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "git" do
  action :remove
end

# Requires
%w[
  curl-devel
  wget
  expat-devel
  gettext-devel
  openssl-devel
  zlib-devel
  perl-ExtUtils-MakeMaker
].each do |p|
  package "#{p}" do
    action :install
  end
end

GIT_VERSION = "2.5.2"
GIT_DIRNAME = "git-#{GIT_VERSION}"
GIT_FILENAME = "#{GIT_DIRNAME}.tar.gz"

# get git file
remote_file "/usr/local/src/#{GIT_FILENAME}" do
  source "https://www.kernel.org/pub/software/scm/git/#{GIT_FILENAME}"
  owner "vagrant"
  group "vagrant"
  mode "0755"
  not_if "ls -l /usr/local/src/ | grep #{GIT_FILENAME}"
end

# extract git file
execute "extract git file" do
  cwd "/usr/local/src"
  user "root"
  group "vagrant"
  command "sudo tar xzvf #{GIT_FILENAME}"
  not_if { File.exists?(GIT_DIRNAME) }
end

execute 'install git' do
  cwd "/usr/local/src/#{GIT_DIRNAME}"
  user "root"
  group "vagrant"
  command "sudo make prefix=/usr/local all && sudo make prefix=/usr/local install"
  not_if "which git"
end
