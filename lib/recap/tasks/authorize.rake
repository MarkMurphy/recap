
desc "Add a GitHub user's public key(s) to the server(s) authorized_keys file"
task :authorize, :username do |task, args|
  on release_roles(:all) do
    username = args.username

    while username.nil? || username.empty? do
      STDOUT.print "GitHub username to authorize?: "
      username = STDIN.gets.chomp
    end

    execute :mkdir, "-p", "~/.ssh"

    within "~/.ssh" do
      key = "#{username}.keys"

      if test :which, "wget"
        execute :wget, "--quiet --timestamping --output-file=\"#{key}\" https://github.com/#{username}.keys"
      else
        execute :curl, "-sS https://github.com/#{username}.keys > #{key}"
      end

      authorized_keys = "~/.ssh/authorized_keys"
      unless test "[ -f #{authorized_keys} ]"
        execute :touch, authorized_keys
      end

      execute :cat, "#{key} >> authorized_keys"
    end
  end
end