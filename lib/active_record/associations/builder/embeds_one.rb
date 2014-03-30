require 'active_record/associations/builder/association'
require 'active_record/associations/builder/singular_association'

module ActiveRecord
  module Associations
    module Builder
      class EmbedsOne < SingularAssociation # :nodoc:
        self.macro = :embeds_one if respond_to?(:macro=)
        self.valid_options = [:class_name]

        # For AR 4.0
        def macro
          :embeds_one
        end
      end
    end
  end
end
