namespace :deploy do

  task :start do
    # invoke 'preflight:check'
    # invoke 'deploy:set_previous_revision'
  end

  task :update do
    invoke 'git:update'
    # invoke 'deploy:set_current_revision'
    # invoke 'deploy:symlink:shared'
  end

  task :publish do
    invoke 'git:release'
    invoke 'git:tag'
  end

  task :finish do
    # invoke 'deploy:log'
  end

  # desc 'Log details of the deploy'
  # task :log do
  #   on release_roles(:all) do
  #     within releases_path do
  #       execute %{echo "#{revision_log_message}" >> #{revision_log}}
  #     end
  #   end
  # end

  # desc 'Revert to previous release timestamp'
  # task :revert => :rollback_release_path do
  #   on release_roles(:all) do
  #     set(:revision_log_message, rollback_log_message)
  #   end
  # end

  # task :new_release_path do
  #   set_release_path
  # end

  # task :rollback_release_path do
  #   on release_roles(:all) do
  #     releases = capture(:ls, '-xr', releases_path).split
  #     if releases.count < 2
  #       error t(:cannot_rollback)
  #       exit 1
  #     end
  #     last_release = releases[1]
  #     set_release_path(last_release)
  #     set(:rollback_timestamp, last_release)
  #   end
  # end

  # desc "Place a REVISION file with the current revision SHA in the current release path"
  # task :set_current_revision  do
  #   invoke 'git:set_current_revision'
  #   on release_roles(:all) do
  #     within release_path do
  #       execute :echo, "\"#{fetch(:current_revision)}\" >> REVISION"
  #     end
  #   end
  # end

  task :set_previous_revision do
    on release_roles(:all) do
      # target = release_path.join('REVISION')
      # if test "[ -f #{target} ]"
      #   set(:previous_revision, capture(:cat, target, '2>/dev/null'))
      # end
      within repo_path do
        set(:previous_revision, invoke("git:fetch_latest_release_tag"))
      end
    end
  end

  # # The `destroy` task can be used in an emergency or when manually testing deployment.  It removes
  # # all previously deployed files, leaving a blank slate to run `deploy:setup` on.
  # desc "Remove all deployed files"
  # task :destroy do
  #   on release_roles(:all) do
  #     if %w(yes y).include? ask(t(:are_you_sure)).to_s.downcase
  #       sudo :rm, "-rf", release_path
  #     end
  #   end
  # end

  task :restart
  task :verify
  task :failed

end