require 'active_support/core_ext/module/delegation'
require 'active_record/reflection'

module ActiveRecord
  module Reflection
    class AssociationReflection # :nodoc:
      def association_class_with_embeds_one
        if macro == :embeds_one
          Associations::EmbedsOneAssociation
        else
          association_class_without_embeds_one
        end
      end
      alias_method_chain :association_class, :embeds_one
    end

    module ClassMethods # :nodoc:
      if ActiveRecord::VERSION::MAJOR < 4
        def create_reflection_with_embeds(macro, name, options, active_record)
          unless macro == :embeds_one
            return create_reflection_without_embeds(macro, name, options, active_record)
          end
          AssociationReflection.new(macro, name, options, active_record).tap do |reflection|
            reflections.merge!(name => reflection)
          end
        end
      else
        def create_reflection_with_embeds(macro, name, scope, options, active_record)
          unless macro == :embeds_one
            return create_reflection_without_embeds(macro, name, scope, options, active_record)
          end
          AssociationReflection.new(macro, name, scope, options, active_record).tap do |reflection|
            reflections.merge!(name => reflection)
          end
        end
      end
      alias_method_chain :create_reflection, :embeds
    end
  end
end
