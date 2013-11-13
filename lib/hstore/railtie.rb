module Hstore
  class Railtie < Rails::Railtie

    initializer 'hstore_document' do
      ActiveSupport.on_load :active_record do
        require 'active_record/embeds_reflection'
        require 'active_record/associations/builder/embeds_one'
        require 'active_record/associations/embeds_one_association'
        require 'hstore/document'
      end
    end

  end
end
