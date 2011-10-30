require 'omniauth/identity/models/mongoid'

class Identity
  include Mongoid::Document
  include OmniAuth::Identity::Models::Mongoid

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
end

