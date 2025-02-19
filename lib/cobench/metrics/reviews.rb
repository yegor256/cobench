# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'iri'
require_relative '../match'

# Reviews in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class Cobench::Reviews
  def initialize(api, user, opts)
    @api = api
    @user = user
    @opts = opts
  end

  def take(loog)
    from = (Time.now - (60 * 60 * 24 * @opts[:days])).strftime('%Y-%m-%d')
    q = "reviewed-by:#{@user} merged:>#{from}"
    json = @api.search_issues(q)
    loog.debug("Found #{json.total_count} reviews")
    msgs = 0
    total = json.items.count do |p|
      pr = p.pull_request.url.split('/')[-1]
      repo = p.repository_url.split('/')[-2..-1].join('/')
      next unless Cobench::Match.new(@opts, loog).matches?(repo)
      loog.debug("Including #{repo}##{pr} reviewed by @#{@user}")
      reviews = @api.pull_request_reviews(repo, pr).count { |c| c[:user][:login].downcase == @user }
      if reviews.zero?
        loog.debug("There are no reviews in #{repo}##{pr} by @#{@user}")
        next
      end
      pr_json = @api.pull_request(repo, pr)
      if pr_json[:user][:login] == @user
        loog.debug("PR #{repo}##{pr} is authored by @#{@user}, skipping it (GitHub API mistake)")
        next
      end
      posted = @api.pull_request_comments(repo, pr).count { |c| c[:user][:login].downcase == @user }
      posted += @api.issue_comments(repo, pr).count { |c| c[:user][:login].downcase == @user }
      loog.debug("#{posted} messages posted by @#{@user} to #{repo}##{pr}")
      msgs += posted
    end
    [
      {
        title: 'Reviews',
        total: total,
        href: Iri.new('https://github.com/search').add(q: q)
      },
      {
        title: 'Msgs',
        total: msgs
      }
    ]
  end
end
