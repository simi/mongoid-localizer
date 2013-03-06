class Dictionary
  include Mongoid::Document
  field :name, type: String
  field :description, type: String, localize: true
end
