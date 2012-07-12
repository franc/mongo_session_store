Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
begin
  
  require 'bson'
  require 'mongoid'
  
  require 'mongo_session_store/mongo_store_base'

  module ActionDispatch
    module Session
      class MongoidStore < MongoStoreBase

         class Session
          include Mongoid::Document
          include Mongoid::Timestamps
          self.store_in :collection => MongoSessionStore.collection_name

          attr_accessible :_id, :data

          field :_id, :type => String

          field :data, :type => String
        end

        private
        def pack(data)
          #BSON::Binary.new(Marshal.dump(data))
          #data.to_hash
          Marshal.dump(data).to_s
        end

        def unpack(packed)
          return nil unless packed
          #Marshal.load(StringIO.new(packed.to_s))
          #HashWithIndifferentAccess.new(packed)
          Marshal.load(packed)
        end
      end
    end
  end

  MongoidStore = ActionDispatch::Session::MongoidStore

#rescue LoadError
end
