# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'iri'
require_relative '../match'

# Issues in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class Cobench::Issues
  def initialize(api, user, opts)
    @api = api
    @user = user
    @opts = opts
  end

  def take(loog)
    from = (Time.now - (60 * 60 * 24 * @opts[:days])).strftime('%Y-%m-%d')
    q = "in:comments type:issue author:#{@user} created:>#{from}"
    json = @api.search_issues(q)
    loog.debug("Found #{json.total_count} issues")
    orgs = []
    total = json.items.count do |p|
      pr = p.url.split('/')[-1]
      repo = p.repository_url.split('/')[-2..-1].join('/')
      next unless Cobench::Match.new(@opts, loog).matches?(repo)
      loog.debug("Including #{repo}#{pr}")
      orgs << p.repository_url.split('/')[-2]
    end
    [
      {
        meta: true,
        title: 'Orgs',
        list: orgs
      },
      {
        title: 'Issues',
        total: total,
        href: Iri.new('https://github.com/search').add(q: q)
      }
    ]
  end
end
