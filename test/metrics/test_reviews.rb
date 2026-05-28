require 'loog'
# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require_relative '../../lib/cobench/metrics/reviews'

# Test for Reviews.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class TestReviews < Minitest::Test
  def test_real
    refute_empty(Cobench::Reviews.new(Octokit::Client.new, 'graur', { days: 2 }).take(Loog::VERBOSE))
  rescue Octokit::TooManyRequests
    skip
  end
end
