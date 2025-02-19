# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require 'loog'
require_relative '../../lib/cobench/metrics/reviews'

# Test for Reviews.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class TestReviews < Minitest::Test
  def test_real
    api = Octokit::Client.new
    m = Cobench::Reviews.new(api, 'graur', { days: 2 })
    ms = m.take(Loog::VERBOSE)
    assert !ms.empty?
  rescue Octokit::TooManyRequests
    skip
  end
end
