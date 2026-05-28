# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'iri'
require_relative '../match'

# Issues in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class Cobench::Issues
  def initialize(api, user, opts)
    @api = api
    @user = user
    @opts = opts
  end

  def take(loog)
    q = "in:comments type:issue author:#{@user} created:>#{since}"
    json = @api.search_issues(q)
    loog.debug("Found #{json.total_count} issues")
    orgs = []
    [
      {
        meta: true,
        title: 'Orgs',
        list: orgs
      },
      {
        title: 'Issues',
        total: json.items.count do |p|
          repo = p.repository_url.split('/')[-2..-1].join('/')
          next unless Cobench::Match.new(@opts, loog).matches?(repo)
          loog.debug("Including #{repo}#{p.url.split('/')[-1]}")
          orgs << p.repository_url.split('/')[-2]
        end,
        href: Iri.new('https://github.com/search').add(q: q)
      }
    ]
  end

  private

  def since
    (Time.now - (60 * 60 * 24 * @opts[:days])).strftime('%Y-%m-%d')
  end
end
