# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require 'loog'
require_relative '../../lib/cobench/metrics/pulls'

# Test for Pulls.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class TestPulls < Minitest::Test
  def test_real
    api = Octokit::Client.new
    m = Cobench::Pulls.new(api, 'yegor256', { days: 5 })
    ms = m.take(Loog::VERBOSE)
    assert !ms.empty?
    p ms
  rescue Octokit::TooManyRequests => e
    puts e.message
    skip
  end
end
