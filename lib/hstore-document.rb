if defined?(Rails)
  require 'hstore/railtie'
else
  require 'active_record'
  require 'active_record/embeds_reflection'
  require 'active_record/associations/builder/embeds_one'
  require 'active_record/associations/embeds_one_association'
  require 'hstore/document'
end
