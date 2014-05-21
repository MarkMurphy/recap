require 'i18n'

en = {
  starting:                    'Starting',
  capified:                    'Capified',
  start:                       'Start',
  update:                      'Update',
  finalize:                    'Finalise',
  finishing:                   'Finishing',
  finished:                    'Finished',
  stage_not_set:               'Stage not set, please call something such as `cap production deploy`, where production is a stage you have defined.',
  written_file:                'create %{file}',
  question:                    'Please enter %{key} (%{default_value}): ',
  keeping_releases:            'Keeping %{keep_releases} of %{releases} deployed releases on %{host}',
  no_old_releases:             'No old releases (keeping newest %{keep_releases}) on %{host}',
  linked_file_does_not_exist:  'linked file %{file} does not exist on %{host}',
  cannot_rollback:             'There are no older releases to rollback to',
  mirror_exists:               'The repository mirror is at %{at}',
  revision_log_message:        'Branch %{branch} (at %{sha}) deployed as release %{release} by %{user}',
  rollback_log_message:        '%{user} rolled back to release %{release}',
  deploy_failed:               'The deploy has failed with an error: %{ex}',
  console: {
    welcome:  'capistrano console - enter command to execute on %{stage}',
    bye:      'bye'
  },
  # Recap
  are_you_sure: "Are you sure? (yes/no)",
  release_message: "Deployed at %{time}",
  application_user_does_not_exist:  "The application user `%{application_user}` does not exist on %{host}.  Did you run the `bootstrap` task?  You can also create this user by logging into the server and running:\n  sudo useradd %{application_user}\n",
  application_group_does_not_exist: "The application group `%{application_group}` does not exist on %{host}.  Did you run the `bootstrap` task?  You can also create this group by logging into the server and running:\n  sudo groupadd %{application_group}\n  sudo usermod --append -G %{application_group} %{application_user}\n",
  remote_git_config_user_not_set:   "Your remote user must have a git user.name and user.email set on %{host}.  Did you run the `bootstrap` task?  You can also set these by logging into the server as %{remote_username} and running:\n  git config --global user.email \"you@example.com\"\n  git config --global user.name \"Your Name\"\n",
  remote_user_not_member_of_application_group: "Your remote user must be a member of the application group `%{application_group}` in order to perform deployments. Did you run the `bootstrap` task?\n You can also add yourself to this group by logging into the server and running:\n  sudo usermod --append -G %{application_group} %{remote_username}\n",
  release_tag_does_not_match_release_matcher: "The release_tag must be matched by the release_matcher regex, %{release_tag} does not match %{release_matcher}"
}

I18n.backend.store_translations(:en, { recap: en })

if I18n.respond_to?(:enforce_available_locales=)
  I18n.enforce_available_locales = true
end