def t(key, options={})
  I18n.t(key, options.merge(scope: :recap))
end

def application
  fetch(:application) { abort "You must set the name of your application in your Capfile, e.g.: set :application, 'tomafro.net'" }
end

def application_user
  fetch(:application_user) || set(:application_user, application)
end

def application_group
  fetch(:application_group) || set(:application_group, application_user)
end

def remote_username
  fetch(:remote_username) || set(:remote_username, capture(:whoami).strip)
end

namespace :preflight do

  desc "Check that the server(s) are properly configured"
  task :check do
    invoke 'preflight:check:application_user_exists'
    invoke 'preflight:check:application_group_exists'
    invoke 'preflight:check:application_user_in_application_group'
    invoke 'preflight:check:git'
    invoke 'git:check'
  end

  namespace :check do
    desc "Check the `application_user` exists."
    task :application_user_exists do
      on release_roles(:all) do |host|
        # Check the `application_user` exists.
        debug "Check the `application_user` (#{application_user}) exists"
        unless test "id #{application_user}"
          error t(:application_user_does_not_exist, application_user: application_user, host: host)
          exit 1
        end
      end
    end

    desc "Check the `application_group` exists."
    task :application_group_exists do
      on release_roles(:all) do |host|
        # Check the `application_group` exists.
        debug "Check the `application_group` (#{application_group}) exists"
        unless test "id -g #{application_group}"
          error t(:application_group_does_not_exist, application_group: application_group, application_user: application_user, host: host)
          exit 1
        end
      end
    end

    desc "Check the remote user is a member of the `application_group`."
    task :application_user_in_application_group do
      on release_roles(:all) do |host|
        # Check the remote user is a member of the `application_group`.
        debug "Check the remote user `#{capture('whoami')}` is a member of the application group `#{application_group}`"
        unless capture(:groups).split(" ").include?(application_group)
          error t(:remote_user_not_member_of_application_group, application_group: application_group, remote_username: remote_username, host: host)
          exit 1
        end
      end
    end

    desc "Check the git configuration exists."
    task :git do
      on release_roles(:all) do |host|
        # Check the git configuration exists.
        debug "Check the git configuration exists."
        if capture('git config user.name || true').strip.empty? || capture('git config user.email || true').strip.empty?
          error t(:remote_git_config_user_not_set, remote_username: remote_username, host: host)
          exit 1
        end
      end
    end
  end
end