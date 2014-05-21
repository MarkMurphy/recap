load File.expand_path("../tasks/git.rake", __FILE__)

require 'capistrano/scm'

class Recap::Git < Capistrano::SCM

  # execute git with argument in the context
  #
  def git(*args)
    args.unshift :git
    context.execute *args
  end

  # The Recap default strategy for git. You should want to use this.
  module DefaultStrategy
    def test
      test! " [ -f #{repo_path}/HEAD ] "
    end

    def check
      test! :git, :'ls-remote -h', repo_url
    end

    def clone
      git :clone, "--recurse-submodules", "--separate-git-dir=#{repo_path}", repo_url, release_path
      # git :clone, "--recurse-submodules", repo_url, repo_path
    end

    def update
      git :remote, :update
    end

    def release
      # git :archive, fetch(:branch), '| tar -x -f - -C', release_path
      git :reset, "--hard origin/#{fetch(:branch)}"
    end

    def fetch_revision
      context.capture(:git, "rev-parse --short #{fetch(:branch)}")
    end
  end
end