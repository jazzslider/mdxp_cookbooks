define :drush_site_install, :action => :install, :dir => nil, :profile => "default", :account_name => nil, :account_pass => nil, :account_mail => nil, :locale => nil, :clean_url => nil, :site_name => nil, :site_mail => nil, :sites_subdir => "default" do
  case params[:action]
  when :install
    include_recipe "drupal::drush"

    if params[:dir] == nil then
      log("drush_site_install definition requires dir") { level :fatal }
      raise "drush_site_install definition requires dir"
    end

    drush_command = "#{node[:drupal][:drush][:dir]}/drush site-install #{params[:profile]} -y --root=\"#{params[:dir]}\" --uri=\"http://#{params[:sites_subdir]}\""

    if params[:account_name] != nil then
      drush_command += " --account-name=\"#{params[:account_name]}\""
    end

    if params[:account_pass] != nil then
      drush_command += " --account-pass=\"#{params[:account_pass]}\""
    end

    if params[:account_mail] != nil then
      drush_command += " --account-mail=\"#{params[:account_mail]}\""
    end

    if params[:locale] != nil then
      drush_command += " --locale=\"#{params[:locale]}\""
    end

    if params[:clean_url] != nil then
      drush_command += " --clean-url=\"#{params[:clean_url]}\""
    end

    if params[:site_name] != nil then
      drush_command += " --site-name=\"#{params[:site_name]}\""
    end

    if params[:site_mail] != nil then
      drush_command += " --site-mail=\"#{params[:site_mail]}\""
    end

    if params[:sites_subdir] != nil then
      drush_command += " --sites-subdir=\"#{params[:sites_subdir]}\""
    end

    # Only run the install if variable "install_task" isn't "done"; otherwise, we've
    # already got a functional database.
    execute drush_command do
      cwd params[:dir]
      user "www-data"
      group "www-data"
      not_if "#{node[:drupal][:drush][:dir]}/drush --root=\"#{params[:dir]}\" --uri=\"http://#{params[:sites_subdir]}\" vget install_task | grep 'install_task: \"done\"'"
    end
  else
    log "drush_site_install #{params[:name]} taking no action."
  end
end
