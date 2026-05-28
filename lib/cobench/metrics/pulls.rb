# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'iri'
require 'time'
require_relative '../match'

# Pulls in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class Cobench::Pulls
  def initialize(api, user, opts)
    @api = api
    @user = user
    @opts = opts
  end

  def take(loog)
    q = "in:comments type:pr author:#{@user} is:merged merged:>#{since}"
    json = @api.search_issues(q)
    loog.debug("Found #{json.total_count} pull requests")
    hoc = 0
    orgs = []
    lcps = []
    [
      {
        meta: true,
        title: 'Orgs',
        list: orgs
      },
      {
        title: 'Pulls',
        total: json.items.count do |p|
          pr = p.pull_request.url.split('/')[-1]
          repo = p.repository_url.split('/')[-2..-1].join('/')
          next unless Cobench::Match.new(@opts, loog).matches?(repo)
          orgs << p.repository_url.split('/')[-2]
          pull = @api.pull_request(repo, pr)
          lcps << (pull[:merged_at] - pull[:created_at])
          hocs = pull.additions + pull.deletions
          hoc += hocs
          loog.debug("Including #{repo}##{pr} with #{hocs}")
        end,
        href: Iri.new('https://github.com/search').add(q: q)
      },
      {
        title: 'LcP',
        total: lcps.empty? ? 0 : Integer((lcps.inject(&:+) / lcps.size) / (60 * 60))
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
