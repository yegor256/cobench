# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'iri'
require_relative '../match'

# Commits in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class Cobench::Commits
  def initialize(api, user, opts)
    @api = api
    @user = user
    @opts = opts
  end

  def take(loog)
    q = "author:#{@user} author-date:>#{since} is:public merge:false"
    json = @api.search_commits(q)
    loog.debug("Found #{json.total_count} commits")
    hoc = 0
    [
      {
        title: 'Commits',
        total: json.items.count do |c|
          sha = c.sha
          repo = c.repository.full_name
          next unless Cobench::Match.new(@opts, loog).matches?(repo)
          loog.debug("Including #{sha} in #{repo}")
          item = @api.commit(repo, sha)
          next unless item
          hocs = item.stats.total
          loog.debug("Found #{hocs} HoC in #{sha}")
          hoc += hocs
        end,
        href: Iri.new('https://github.com/search').add(q: q)
      },
      {
        title: 'HoC',
        total: hoc
      }
    ]
  end

  private

  def since
    (Time.now - (60 * 60 * 24 * @opts[:days])).strftime('%Y-%m-%d')
  end
end
