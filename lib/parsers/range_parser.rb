#!/usr/bin/env ruby

# This script parses report ranges:
# - a year_s         (optional)
# - a month_s        (optional)
# - a quarter_s      (optional)
# - a current_s      (optional)
# - a span           (optional)
# - a year_f         (optional)
# - a month_f        (optional)
# - a quarter_f      (optional)
# - a current_f      (optional)
#
# The script depends on the Parslet gem, written by Florian Hanke
# and maintained by Kaspar Schiess.
#
# For development, execute this script from the command line to run the test cases.
#
# For production, require parsers/name_parser, then:
#     name_hash = Parsers::RangeParser.new.parse(input_string)
#

require 'rubygems'
require 'parslet'

module Parsers
  class RangeParser < Parslet::Parser

    # case insensitive string match - copied from the 'Parslet Tips' page...
    def stri(str)
      chars = str.split(//)
      chars.map {|c| match["#{c.upcase}#{c.downcase}"] }.reduce(:>>)
    end

    def month_match
      months = %w(january february march april may june
      july august september november december
      jan feb mar apr may jun jul aug sep oct nov dec
      01 02 03 04 05 06 07 08 09 10 11 12
      1 2 3 4 5 6 7 8 9)
      months.map {|s| stri(s)}.reduce(:|)
    end

    def quarter_match
      quarters = %w(q1 q2 q3 q4)
      quarters.map {|s| stri(s)}.reduce(:|)
    end

    def current_match
      strings = %w(current cur c)
      strings.map {|s| stri(s)}.reduce(:|)
    end

    # Building Blocks
    rule(:space)      { match('[ \-]').maybe  }
    rule(:period)     { str('.')              }
    rule(:digit)      { match('[0-9]')        }
    rule(:rdigit)     { digit.repeat(1)       }

    # Things
    rule(:year)        { str('20') >> digit >> digit        }
    rule(:current_val) { match('[ \+\-]') >> rdigit         }
    rule(:current)     { current_match >> current_val.maybe }
    rule(:span_c)      { period >> period.repeat(1)         }

    # Match Elements
    rule(:year_s)      { year.as(:year_s)              }
    rule(:month_s)     { month_match.as(:month_s)      }
    rule(:current_s)   { current.as(:current_s)        }
    rule(:quarter_s)   { quarter_match.as(:quarter_s)  }
    rule(:span)        { span_c.as(:span)              }
    rule(:year_f)      { year.as(:year_f)              }
    rule(:month_f)     { month_match.as(:month_f)      }
    rule(:current_f)   { current.as(:current_f)        }
    rule(:quarter_f)   { quarter_match.as(:quarter_f)  }

    # Intermediate
    rule(:opt_year_s)             { year_s.maybe                }
    rule(:opt_year_f)             { year_f.maybe                }
    rule(:opt_month_or_quarter_s) { (month_s | quarter_s).maybe }
    rule(:opt_month_or_quarter_f) { (month_f | quarter_f).maybe }

    rule(:start_d)  { opt_year_s >> space >> opt_month_or_quarter_s }
    rule(:start)    { current_s | start_d                           }
    rule(:finish_d) { opt_year_f >> space >> opt_month_or_quarter_f }
    rule(:finish)   { current_f | finish_d                          }

    # Top-Level
    rule(:all)  { (start >> span >> finish) | start }
    root(:all)
  end
end

if $0 == __FILE__

  def test_runner(rule, string)
    begin
      parser = Parsers::RangeParser.new
      eval "p parser.#{rule}.parse('#{string}')"
    rescue Parslet::ParseFailed => e
      puts "FAIL> #{rule}".rjust(20, '-') + ' > ' + string.gsub("\n",'/').ljust(60, '-')
      puts e.cause.ascii_tree
    end
  end

  # Test cases...
  test_runner 'space'     , ' '
  test_runner 'space'     , '-'
  test_runner 'span'      , '..'
  test_runner 'span'      , '...'
  test_runner 'year_s'    , '2014'
  test_runner 'month_s'   , 'Jan'
  test_runner 'month_s'   , '01'
  test_runner 'month_s'   , 'june'
  test_runner 'quarter_s' , 'Q4'
  test_runner 'current_s' , 'current'
  test_runner 'current_s' , 'current-3'
  test_runner 'current_s' , 'current 3'
  test_runner 'current_s' , 'current+3'
  test_runner 'start'     , '2014-Jan'
  test_runner 'start'     , '2014-03'
  test_runner 'start'     , '2014'
  test_runner 'start'     , '2014Jan'
  test_runner 'start'     , '2014-Jan'
  test_runner 'start'     , '2014-03'
  test_runner 'start'     , '201403'
  test_runner 'start'     , '2014-Q2'
  test_runner 'start'     , '2014'
  test_runner 'start'     , '2014-02'
  test_runner 'start'     , '2014-feb'
  test_runner 'start'     , '2014feb'
  test_runner 'start'     , '2014 feb'
  test_runner 'start'     , '2014 q4'
  test_runner 'start'     , '2014q4'
  test_runner 'start'     , '2014'
  test_runner 'start'     , '2014-Q3'
  test_runner 'start'     , '2014-Q3'
  test_runner 'start'     , 'Q3'
  test_runner 'start'     , 'May'
  test_runner 'start'     , '03'
  test_runner 'start'     , 'current'
  test_runner 'start'     , 'c'
  test_runner 'start'     , 'cur'
  test_runner 'start'     , 'current 4'
  test_runner 'start'     , 'current-2'
  test_runner 'start'     , 'C-2'
  test_runner 'all'       , 'current..current+3'
  test_runner 'all'       , 'current'
  test_runner 'all'       , 'current+1'
  test_runner 'all'       , '2014..2015'
  test_runner 'all'       , '2014Jan..2015Q2'
  test_runner 'all'       , '2014...2015'
  test_runner 'all'       , '2014...Q4'
  test_runner 'all'       , '2014-Feb...Q4'
  test_runner 'all'       , '2014-07...Q4'
  test_runner 'all'       , '2014-07...current+1'

end
