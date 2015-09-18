# gem_package "rubygems-update"
gem_package "rubygems-update" do
  action :install
end
# execute "gem install rubygems-update" do
#   command "gem install rubygems-update"
#   user "vagrant"
#   action :run
#   not_if "gem list | grep rubygems-update"
# end
#
execute "update_rubygems" do
  command "update_rubygems"
  user "vagrant"
  action :run
end

%w[
  bundler
].each do |p|
  gem_package "#{p}" do
    action :install
  end
end

# # gem_package "bundler"
# execute "gem install bundler" do
#   command "gem install bundler"
#   user "vagrant"
#   action :run
#   not_if "gem list | grep bundler"
# end
#
