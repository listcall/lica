#!/usr/bin/env ruby

# This script parses Names, and extracts:
# - a title         (optional)
# - a first name    (required)
# - a middle name   (optional)
# - a last name     (required)
#
# The script depends on the Parslet gem, written by Florian Hanke
# and maintained by Kaspar Schiess.
#
# For development, execute this script from the command line to run the test cases.
#
# For production, require parsers/name_parser, then:
#     name_hash = Parsers::NameParser.new.parse(input_string)
#
# This parser works pretty well, but doesn't handle multiple middle names.
# Also it doesn't handle 'Jr' or 'III'...
#
# To handle multiple middle names, explore one of two approaches:
# 1. post to the Parslet mailing list to see if anyone knows a solution
# 2. make a two-pass parser.
# - First Pass: pull off the last name
# - Second Pass: parse the rest of the text and grab the remaining fields

require 'rubygems'
require 'parslet'

module Parsers
  class NameParser < Parslet::Parser

    # case insensitive string match - copied from the 'Parslet Tips' page...
    def stri(str)
      chars = str.split(//)
      chars.map {|c| match["#{c.upcase}#{c.downcase}"] }.reduce(:>>)
    end

    # titles
    def title_match
      full_titles = %w(
        doctor
        sheriff
        chief
        deputy
        commander
        colonel
        major
        captain
        lieutenant
        sargent
        corporal
        trooper
        officer
        inspector
        detective
      )
      abbreviations = %w( dr com col maj capt cap lt sgt ofc det )
      full = full_titles.map   {|s| stri(s)}
      abbs = abbreviations.map {|s| stri(s) >> str('.')}
      abbr = abbreviations.map {|s| stri(s)}
      (full + abbs + abbr).reduce(:|)
    end

    def anchor_match
      anchors = %w(van von de)
      anchors.map {|s| stri(s)}.reduce(:|)
    end

    def article_match
      articles = %w(den der la de)
      articles.map {|s| stri(s)}.reduce(:|)
    end

    # Single character rules
    rule(:period)     { str('.') }
    rule(:comma)      { str(',') >> space? }
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }
    rule(:digit)      { match('[0-9\-]') }
    rule(:eof)        { any.absent? }

    # For Testing
    rule(:title_test)  { title_match }

    # Things
    rule(:word)        { match('[A-Za-z\-\.]').repeat(1) }
    rule(:anchor)      { anchor_match >> space }
    rule(:article)     { article_match >> space }

    # Match Elements
    rule(:title)       { title_match.as(:title) >> space }
    rule(:first_name)  { word.as(:first_name) >> space }
    rule(:middle_name) { word.as(:middle_name) >> space }
    rule(:last_name)   { (
      (anchor >> article >> word).as(:last_name) >> space? >> eof |
      (anchor >> word).as(:last_name) >> space? >> eof |
      (word).as(:last_name) >> space? >> eof
    ) }

    # Top-Level
    rule(:all) {
      (title >> first_name >> middle_name >> last_name) |
      (title >> first_name >>                last_name) |
      (         first_name >> middle_name >> last_name) |
      (         first_name >>                last_name)
    }
    root :all
  end
end

if $0 == __FILE__

  def test_runner(rule, string)
    begin
      parser = Parsers::NameParser.new
      eval "p parser.#{rule}.parse('#{string}')"
    rescue Parslet::ParseFailed => e
      puts "FAIL> #{rule}".rjust(20, '-') + ' > ' + string.gsub("\n",'/').ljust(60, '-')
      puts e.cause.ascii_tree
    end
  end

  # Test cases...
  test_runner       'title_test', 'dr'
  test_runner       'title_test', 'sargent'
  test_runner             'word', 'sue'
  test_runner             'word', 'sue-bob'
  test_runner             'word', 'J.R.R.'
  test_runner            'title', 'col. '
  test_runner            'title', 'lt. '
  test_runner              'all', 'joe smith'
  test_runner              'all', 'joe middle smith'
  test_runner              'all', 'dr joe random smith'
  test_runner              'all', 'dr joe smith'
  test_runner              'all', 'dr. jim smith van bracket'
  test_runner              'all', 'dr. jim smith jones van de bracket'

end
