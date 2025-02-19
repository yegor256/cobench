# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'iri'
require_relative '../match'

# Commits in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class Cobench::Commits
  def initialize(api, user, opts)
    @api = api
    @user = user
    @opts = opts
  end

  def take(loog)
    from = (Time.now - (60 * 60 * 24 * @opts[:days])).strftime('%Y-%m-%d')
    q = "author:#{@user} author-date:>#{from} is:public merge:false"
    json = @api.search_commits(q)
    loog.debug("Found #{json.total_count} commits")
    hoc = 0
    total = json.items.count do |c|
      sha = c.sha
      repo = c.repository.full_name
      next unless Cobench::Match.new(@opts, loog).matches?(repo)
      loog.debug("Including #{sha} in #{repo}")
      json = @api.commit(repo, sha)
      next unless json
      hocs = json.stats.total
      loog.debug("Found #{hocs} HoC in #{sha}")
      hoc += hocs
    end
    [
      {
        title: 'Commits',
        total: total,
        href: Iri.new('https://github.com/search').add(q: q)
      },
      {
        title: 'HoC',
        total: hoc
      }
    ]
  end
end
