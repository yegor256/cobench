# Copyright (c) 2022-2024 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'iri'
require_relative '../match'

# Commits in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2024 Yegor Bugayenko
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
