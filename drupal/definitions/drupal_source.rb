define :drupal_source, :action => :create, :version => "6.20" do
  case params[:action]
  when :create
    include_recipe "drupal::drush" 

    directory "#{params[:name]}" do
      owner "www-data"
      group "www-data"
      mode "0755"
      recursive true
      action :create
    end

    execute "download-drupal-source-to-#{params[:name]}" do
      cwd "/tmp"
      command "#{node[:drupal][:drush][:dir]}/drush dl drupal-#{params[:version]} -y --destination=#{File.dirname(params[:name])} --drupal-project-rename=#{File.basename(params[:name])}"
      not_if "#{node[:drupal][:drush][:dir]}/drush -r #{params[:name]} core-status | grep #{params[:version]}"
    end

    directory "#{params[:name]}/sites/default/files" do
      mode "0777"
      action :create
    end 
  when :delete
    directory "#{params[:name]}" do
      recursive true
      action :delete
    end
  else
    log "drupal_source action #{params[:name]} is unrecognized."
  end
end
