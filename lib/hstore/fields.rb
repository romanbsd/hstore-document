module Hstore
  module Fields # :nodoc:

    class Boolean
      def self.load(str)
        case str
        when 't'
          true
        when 'f'
          false
        else
          nil
        end
      end

      def self.dump(obj)
        case obj
        when true
          't'
        when false
          'f'
        else
          nil
        end
      end
    end

    class Fixnum
      def self.load(str)
        str.to_i if str.present?
      end

      def self.dump(obj)
        obj.to_s
      end
    end
    Integer = Fixnum

    class Array
      def self.load(str)
        MultiJson.load(str) if str.present?
      end

      def self.dump(obj)
        MultiJson.dump(obj)
      end
    end

    class Time
      def self.load(str)
        Time.parse(str) if str.present?
      end

      def self.dump(obj)
        obj.strftime("%Y-%m-%d %H:%M:%S") if obj.present?
      end
    end

  end
end
