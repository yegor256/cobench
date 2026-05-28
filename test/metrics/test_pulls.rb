require 'loog'
# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require_relative '../../lib/cobench/metrics/pulls'

# Test for Pulls.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class TestPulls < Minitest::Test
  def test_real
    ms = Cobench::Pulls.new(Octokit::Client.new, 'yegor256', { days: 5 }).take(Loog::VERBOSE)
    refute_empty(ms)
    p(ms)
  rescue Octokit::TooManyRequests => e
    puts(e.message)
    skip('GitHub API rate limit exceeded')
  end
end
