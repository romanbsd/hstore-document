class Address
  include Hstore::Document

  field :street, type: String, default: 'unknown'
  field :number, type: Fixnum
  field :business, type: Boolean

  validates_presence_of :number
end

class StrictAddress < Address
  validates_presence_of :street
  validates_numericality_of :number
end

class Person < ActiveRecord::Base
  embeds :address

  accepts_nested_attributes_for :address
end
