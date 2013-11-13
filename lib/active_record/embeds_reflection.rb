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
      def create_reflection(macro, name, options, active_record)
        case macro
        when :has_many, :belongs_to, :has_one, :has_and_belongs_to_many, :embeds_one
          klass = options[:through] ? ThroughReflection : AssociationReflection
          reflection = klass.new(macro, name, options, active_record)
        when :composed_of
          reflection = AggregateReflection.new(macro, name, options, active_record)
        end

        # The original had:
        # self.reflections = self.reflections.merge(name => reflection)
        reflections.merge!(name => reflection)
        reflection
      end
    end
  end
end
