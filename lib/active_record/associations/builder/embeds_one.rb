require 'active_record/associations/builder/association'
require 'active_record/associations/builder/singular_association'

module ActiveRecord
  module Associations
    module Builder
      class EmbedsOne < SingularAssociation # :nodoc:
        self.macro = :embeds_one
        self.valid_options = [:class_name]
      end
    end
  end
end
