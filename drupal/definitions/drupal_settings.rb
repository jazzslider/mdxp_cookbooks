define :drupal_settings, :action => :create, :dir => nil, :site => "default", :database => nil, :user => nil, :password => nil do
  # Leave the directory in place even if :action is :delete;
  # we don't want to end up deleting a bunch of extra files
  # that aren't technically the resource this definition manages.
  directory "#{params[:dir]}/sites/#{params[:site]}" do
    owner "www-data"
    group "www-data"
    mode "0755"
    recursive true
    action :create
  end

  case params[:action]
  when :create
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
  when :delete
    file "#{params[:dir]}/sites/#{params[:site]}/settings.php" do
      action :delete
    end
  else
    log "drupal_settings action #{params[:action]} is unrecognized."
  end
end
