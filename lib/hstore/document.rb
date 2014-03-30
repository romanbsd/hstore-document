require 'active_support/concern'
require 'active_model/naming'
require 'active_model/conversion'
require 'active_model/translation'
require 'active_model/validations'
require 'active_record/readonly_attributes'
require 'pg_hstore'
require 'hstore/fields'

module Hstore
  module Document
    extend ActiveSupport::Concern

    included do
      include Hstore::Fields
      include ActiveModel::Conversion
      include ActiveModel::Validations
      include ActiveModel::Serialization
      include ActiveModel::Dirty
      include ActiveModel::AttributeMethods
      include ActiveRecord::AttributeAssignment
      include ActiveRecord::ReadonlyAttributes
      include ActiveRecord::AttributeMethods::BeforeTypeCast
      include ActiveRecord::AttributeMethods::Serialization
      extend ActiveModel::Naming

      class << self
        def attributes_protected_by_default
          []
        end
      end

      class_attribute :_attr_defaults, instance_writer: false
      self._attr_defaults = {}
      alias_method :as_json, :serializable_hash
    end

    Attribute = ActiveRecord::AttributeMethods::Serialization::Attribute
    class OwnerMissingError < StandardError; end

    def initialize(attributes = nil, options = {})
      @attributes = {}
      assign_attributes(self.class._attr_defaults)

      if options[:serialized] and attributes.present?
        attributes = attributes.stringify_keys
        self.class.serialized_attributes.each do |key, coder|
          if attributes.key?(key)
            attributes[key] = Attribute.new(coder, attributes[key], :serialized)
          end
        end
        assign_attributes(attributes.except(self.class.serialized_attributes.keys))
      else
        assign_attributes(attributes)
      end
      changed_attributes.clear
    end

    def attributes
      attrs = {}
      @attributes.each_key { |name| attrs[name] = read_attribute(name) }
      attrs
    end

    def eql?(other)
      other.attributes == attributes
    end
    alias :== :eql?

    def update_attribute(name, value)
      name = name.to_s
      raise ActiveRecordError, "#{name} is marked as readonly" if self.class.readonly_attributes.include?(name)
      send("#{name}=", value)
      save(validate: false)
    end

    def read_attribute(name)
      name = name.to_s
      if @attributes.key?(name)
        val = @attributes[name]
        if self.class.serialized_attributes.key?(name)
          val = val.unserialized_value
        end
        val
      else
        _attr_defaults[name]
      end
    end

    def write_attribute(name, value)
      name = name.to_s
      if coder = self.class.serialized_attributes[name] and ! value.respond_to?(:serialized_value)
        value = Attribute.new(coder, value, :unserialized)
      end
      attribute_will_change!(name)
      @attributes[name] = value
    end

    def update_attributes(attributes, options)
      assign_attributes(attributes, options)
      save
    end

    def update_attributes!(attributes, options)
      assign_attributes(attributes, options)
      save!
    end

    def persisted?
      ! changed? && _owner && _owner.persisted?
    end

    def destroyed?
      @_destroyed || (_owner && _owner.destroyed?)
    end

    def marked_for_destruction?
      _owner && _owner.marked_for_destruction?
    end

    def save(options = {})
      perform_validations(options) ? create_or_update : false
    end

    # XXX the proper way would have been to introduce an embedded_in macro, which would
    # even support polymorphic associations, but it's a lot of work, overhead, and I
    # think that accesing the parent from embedded object should be discouraged as a matter
    # of principle.
    def destroy
      @_destroyed = true
      _owner.update_attribute(embedded_as, nil) if _owner
    end

    def to_hstore
      PgHstore.dump(attributes_after_type_cast, true)
    end

    private

    attr_accessor :_owner

    def embedded_as
      self.class.name.demodulize.underscore
    end

    def perform_validations(options = {})
      perform_validation = options[:validate] != false
      perform_validation ? valid?(options[:context]) : true
    end

    def create_or_update
      raise OwnerMissingError unless _owner
      changed_attributes.clear if _owner.update_attribute(embedded_as, self)
    end

    def attributes_after_type_cast
      @attributes.dup.tap do |attributes|
        self.class.serialized_attributes.each_key do |key|
          if attributes.key?(key)
            attributes[key] = attributes[key].serialized_value
          end
        end
      end
    end

    module ClassMethods

      def from_hstore(data)
        if ActiveRecord::VERSION::MAJOR < 4
          data = PgHstore.load(data)
        end
        new(data, serialized: true)
      end

      def field(name, options = {})
        klass = options[:type]

        default = options[:default]
        _attr_defaults[name.to_s] = default unless default.nil?

        if klass.to_s.start_with?('Hstore::Fields::')
          serialize(name, klass)
        end
        define_accessors(name)
      end

      private
      def define_accessors(name)
        define_reader name
        define_writer name
      end

      def define_reader(name)
        define_method(name) do
          read_attribute(name)
        end
      end

      def define_writer(name)
        define_method("#{name}=".to_sym) do |value|
          write_attribute(name, value)
        end
      end
    end

  end
end

=begin
$: << Dir.pwd + '/lib'; true
require 'hstore-document'
ActiveRecord::Base.establish_connection(adapter: 'postgresql', database: 'hstore_document', username: 'postgres', password: 'postgres')
class Address; include Hstore::Document; field :street; end
class Person < ActiveRecord::Base; embeds :address; end
a = Address.new(bar: true)
p = Person.new(address: a)
=end
