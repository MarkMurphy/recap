namespace :deploy do

  desc 'Start a deployment, make sure server(s) ready.'
  task :start do
  end

  desc 'Update server(s) by setting up a new release.'
  task :update do
  end

  desc 'Revert server(s) to previous release.'
  task :revert do
  end

  desc 'Publish the release.'
  task :publish do
  end

  desc 'Restart services running on the server(s).'
  task :restart do
  end

  desc 'Finish the deployment, clean up server(s).'
  task :finish do
  end

  desc 'Rollback to previous release.'
  task :rollback do
    %w{ start revert publish restart finish }.each do |task|
      invoke "deploy:#{task}"
    end
  end

  task :failed
end

desc 'Deploy a new release.'
task :deploy do
  set(:deploying, true)
  %w{ start update publish restart finish }.each do |task|
    on release_roles(:all) do
      info "Running deploy:#{task} task(s)..."
      puts "################################################################################"
    end

    invoke "deploy:#{task}"

    on release_roles(:all) do
      puts "DONE."
      puts
    end
  end
end
task default: :deploy