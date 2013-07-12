require 'net/https'

module Kender

  # This module abstracts access to GitHub. It's current, sole purpose is to
  # allow commit statuses to be created.
  #
  # See: https://github.com/blog/1227-commit-status-api
  #
  module GitHub
    extend self

    # Update the commit status for the current HEAD commit. Assumes the working
    # directory is a git repo and the "origin" remote points to a GitHub repo.
    # The +state+ variable must be one of :pending, :success or :failure. The
    # +config+ object must respond to +build_number+, +build_url+ and
    # +github_auth_token+.
    #
    def update_commit_status(state, config)

      # TODO: Refactor the following code to use gems like git/grit/rugged and
      # octokit. ~asmith

      unless config.github_auth_token
        puts "Skipping setting the status on Github to #{state} because the access token is not configured"
        return
      end

      body = %Q({
        "state": "#{state.to_s}",
        "target_url": "#{config.build_url}",
        "description": "Continuous integration run #{config.build_number}"
      })
      commit = `git log -1 --format=format:%H`
      remotes = `git remote --verbose`
      remote_name = ENV['GITHUB_REMOTE'] || 'origin'

      unless repo = /^#{remote_name}\s+git@(\w+\.)?github.com:([\w-]+\/[\w-]+)\b/.match(remotes).to_a.last
        puts "Could not establish GitHub repo name from '#{remote_name}' remote"
        return
      end
      uri = URI("https://api.github.com/repos/#{repo}/statuses/#{commit}?access_token=#{config.github_auth_token}")

      puts "Setting #{repo} commit #{commit} status to '#{state}' on GitHub"

      Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
        response = http.post(uri.request_uri, body)
        unless response.is_a?(Net::HTTPCreated)
          puts "Setting commit status FAILED", response
        end
      end
    end
  end
end

