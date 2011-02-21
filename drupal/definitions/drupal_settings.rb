define :drupal_settings, :dir => nil, :site => "default", :database => nil, :user => nil, :password => nil do
  directory "#{params[:dir]}/sites/#{params[:site]}" do
    owner "www-data"
    group "www-data"
    mode "0755"
    recursive true
    action :create
  end

  template "#{params[:dir]}/sites/#{params[:site]}/settings.php" do
    source "settings.php.erb"
    cookbook "drupal"
    mode "0644"
    variables(
      :database => params[:database],
      :user     => params[:user],
      :password => params[:password]
    )
  end
end
