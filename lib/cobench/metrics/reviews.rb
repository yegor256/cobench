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

# Reviews in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2024 Yegor Bugayenko
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
