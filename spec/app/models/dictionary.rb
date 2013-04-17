class Dictionary
  include Mongoid::Document
  field :name, type: String
  field :description, type: String, localize: true
  field :slug, type: String, localize: {prevent_fallback: true}
end
