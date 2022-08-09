# Copyright (c) 2022 Yegor Bugayenko
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
require_relative '../mask'

# Pulls in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022 Yegor Bugayenko
# License:: MIT
class Cobench::Pulls
  def initialize(api, user, opts)
    @api = api
    @user = user
    @opts = opts
  end

  def take(loog)
    from = (Time.now - (60 * 60 * 24 * @opts[:days])).strftime('%Y-%m-%d')
    q = "#{@user} in:comments type:pr author:#{@user} is:merged closed:>#{from}"
    json = @api.search_issues(q)
    total = json.items.count do |p|
      pr = p.pull_request.url.split('/')[-1]
      repo = p.repository_url.split('/')[-2..-1].join('/')
      if @opts[:include].none? { |m| Cobench::Mask.new(m).matches?(repo) }
        loog.debug("Excluding #{repo}##{pr} due to lack of --include")
        next
      end
      if @opts[:exclude].any? { |m| Cobench::Mask.new(m).matches?(repo) }
        loog.debug("Excluding #{repo}##{pr} due to --exclude")
        next
      end
      loog.debug("Including #{repo}#{pr}")
    end
    [total, Iri.new('https://github.com/search').add(q: q)]
  end
end