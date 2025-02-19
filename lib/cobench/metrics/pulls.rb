# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'iri'
require 'time'
require_relative '../match'

# Pulls in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class Cobench::Pulls
  def initialize(api, user, opts)
    @api = api
    @user = user
    @opts = opts
  end

  def take(loog)
    from = (Time.now - (60 * 60 * 24 * @opts[:days])).strftime('%Y-%m-%d')
    q = "in:comments type:pr author:#{@user} is:merged merged:>#{from}"
    json = @api.search_issues(q)
    loog.debug("Found #{json.total_count} pull requests")
    hoc = 0
    orgs = []
    lcps = []
    total = json.items.count do |p|
      pr = p.pull_request.url.split('/')[-1]
      repo = p.repository_url.split('/')[-2..-1].join('/')
      next unless Cobench::Match.new(@opts, loog).matches?(repo)
      orgs << p.repository_url.split('/')[-2]
      pr_json = @api.pull_request(repo, pr)
      lcps << (pr_json[:merged_at] - pr_json[:created_at])
      hocs = pr_json.additions + pr_json.deletions
      hoc += hocs
      loog.debug("Including #{repo}##{pr} with #{hocs}")
    end
    [
      {
        meta: true,
        title: 'Orgs',
        list: orgs
      },
      {
        title: 'Pulls',
        total: total,
        href: Iri.new('https://github.com/search').add(q: q)
      },
      {
        title: 'LcP',
        total: lcps.empty? ? 0 : ((lcps.inject(&:+) / lcps.size) / (60 * 60)).to_i
      },
      {
        title: 'HoC',
        total: hoc
      }
    ]
  end
end
