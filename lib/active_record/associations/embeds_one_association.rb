require 'active_record/associations/association'

module ActiveRecord
  module Associations
    if (ActiveRecord.version.segments[0] + ActiveRecord.version.segments[1] / 10.0) >= 4.1
      module ClassMethods
        # @param [Symbol, String] name of association
        # @param scope
        # @param [Hash] options
        # @option options [Boolean] :validate Validate associaited object (default: true)
        # @option options [String] :class_name Name of the associated class
        def embeds(name, scope = nil, options = {}, &extension)
          validates_associated(name) unless options.delete(:validate) == false
          reflection = Builder::EmbedsOne.build(self, name, options, nil)
          Reflection.add_reflection self, name, reflection
        end
      end
    else
      module ClassMethods
        # @param [Symbol, String] name of association
        # @param [Hash] options
        # @option options [Boolean] :validate Validate associaited object (default: true)
        # @option options [String] :class_name Name of the associated class
        def embeds(name, options = {})
          validates_associated(name) unless options.delete(:validate) == false
          if ActiveRecord::VERSION::MAJOR < 4
            Builder::EmbedsOne.build(self, name, options)
          else
            Builder::EmbedsOne.build(self, name, options, nil)
          end
        end
      end
    end

    class EmbedsOneAssociation < Association # :nodoc:
      def reader(force_reload = false)
        return @reader if @reader
        data = owner.read_attribute(reflection.name)
        if data.present?
          reflection.klass.from_hstore(data).tap do |inst|
            inst.send(:_owner=, owner)
            @reader = inst
          end
        end
      end

      def writer(record)
        replace(record, false)
      end

      def replace(record, save = true)
        @reader = record
        if record
          record.send(:_owner=, owner)
        end
        owner.send(:write_attribute, reflection.name, record ? record.to_hstore : nil)
        owner.save if save
      end

      def create(attributes = {}, options = {}, &block)
        create_record(attributes, options, &block)
      end

      def create!(attributes = {}, options = {}, &block)
        create_record(attributes, options, true, &block)
      end

      def build(attributes = {}, options = {})
        build_record(attributes, options).tap do |record|
          yield(record) if block_given?
          replace(record, false)
        end
      end

      private
      def build_record(attributes, options = nil)
        reflection.build_association(attributes) do |record|
          record.assign_attributes(attributes, without_protection: true)
        end
      end

      def create_record(attributes, options, raise_error = false)
        build_record(attributes, options).tap do |record|
          yield record if block_given?
          saved = replace(record)
          raise RecordInvalid.new(record) if !saved && raise_error
        end
      end

    end
  end
end
