def release_tag
  fetch(:release_tag) || set(:release_tag, Time.now.utc.strftime("%Y%m%d%H%M%S"))
end

def release_matcher
  fetch(:release_matcher) || set(:release_matcher, /\A[0-9]{14}\Z/)
end

def release_message
  fetch(:release_message) || set(:release_message, t(:release_message, time: Time.now))
end


namespace :git do

  def strategy
    @strategy ||= Recap::Git.new(self, fetch(:git_strategy, Recap::Git::DefaultStrategy))
  end


  desc 'Check that the repository is reachable'
  task :check do
    fetch(:branch)
    on release_roles :all do
      exit 1 unless strategy.check
    end
  end

  desc 'Clone the repository'
  task :clone do
    on release_roles :all do
      if strategy.test
        info t(:mirror_exists, at: repo_path)
      else
        within deploy_path do
          strategy.clone
        end
      end
    end
  end

  desc 'Update the repository mirror to reflect the origin state'
  task update: :'git:clone' do
    on release_roles :all do
      within repo_path do
        strategy.update
      end
    end
  end

  desc 'Resets the index and working tree to reflect the current origin state'
  task :release do
    on release_roles :all do
      within repo_path do
        strategy.release
      end
    end
  end

  # Tag `HEAD` with the release tag and message
  task :tag do
    unless release_tag =~ release_matcher
      error t(:release_tag_does_not_match_release_matcher, release_tag: release_tag, release_matcher: release_matcher)
      exit 1
    end
    on release_roles :all do
      within repo_path do
        # on_rollback { git "tag -d #{release_tag}" }
        execute :git, "tag #{release_tag} -m \"#{release_message}\""
      end
    end
  end

  desc 'Determine the revision that will be deployed'
  task :set_current_revision do
    on release_roles :all do
      within repo_path do
        set :current_revision, strategy.fetch_revision
      end
    end
  end

  task :fetch_latest_release_tag do
    on release_roles :all do
      within repo_path do
        tags = capture(:git, "tag").strip.split
        tags.grep(release_matcher).last
      end
    end
  end

end