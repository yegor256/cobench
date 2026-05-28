require 'loog'
# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/cobench/match'

# Test for Match.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class TestMatch < Minitest::Test
  def test_positive
    assert(Cobench::Match.new({ include: [], exclude: [] }, Loog::NULL).matches?('foo/bar'))
  end

  def test_negative
    refute(Cobench::Match.new({ include: ['*/*'], exclude: ['foo/*'] }, Loog::NULL).matches?('foo/bar'))
  end
end
