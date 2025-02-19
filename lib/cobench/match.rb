# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative 'mask'

# Match of masks.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class Cobench::Match
  def initialize(opts, loog)
    @opts = opts
    @loog = loog
  end

  def matches?(repo)
    if @opts[:include] && !@opts[:include].empty? && @opts[:include].none? { |m| Cobench::Mask.new(m).matches?(repo) }
      @loog.debug("Excluding #{repo} due to lack of --include")
      return false
    end
    if @opts[:exclude] && @opts[:exclude].any? { |m| Cobench::Mask.new(m).matches?(repo) }
      @loog.debug("Excluding #{repo} due to --exclude")
      return false
    end
    true
  end
end
