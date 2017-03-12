# require 'app_ext/pkg'
#
# class AppExtTst < ActiveRecord::Base
#
#   extend AppExt::Accessor
#
#   # ----- Attributes -----
#
#   xfields_accessor :xf0
#   xfields_accessor :xf1, default: 0
#   xfields_accessor :xf2, default: []
#   xfields_accessor :xf3, default: {}
#
#   jfields_accessor :jf1, :jf2, default: 0
#
#   jnested_accessor :jb1, :jb2
#   jnested_accessor :jb3
#   jnested_accessor :jb4
#   jnested_accessor :jb5, column: 'jdatab'
#
#   upcase_field :title, :sarr1
#
# end

# == Schema Information
#
# Table name: app_ext_tsts
#
#  id         :integer          not null, primary key
#  title      :string
#  _config    :json             default("{}")
#  xfields    :hstore           default("")
#  jfields    :json             default("{}")
#  jdatab     :jsonb            default("{}")
#  iarr1      :integer          default("{}"), is an Array
#  iarr2      :integer          default("{}"), is an Array
#  sarr1      :string           default("{}"), is an Array
#  sarr2      :string           default("{}"), is an Array
#  created_at :datetime
#  updated_at :datetime
#
