# TODO: Add documention links for this area once the docs has been made public
class Podio::Grant < ActivePodio::Base

  property :ref_type, :string
  property :ref_id, :integer
  property :people, :hash
  property :action, :string
  property :message, :string
  property :ref, :hash
  property :created_on, :datetime

  has_one :created_by, :class => 'ByLine'
  has_one :user, :class => 'Contact'

  def save
    self.class.create(self.ref_type, self.ref_id, self.attributes)
  end

  handle_api_errors_for :save

  class << self
    # https://hoist.podio.com/api/item/16168841
    def create(ref_type, ref_id, attributes={})
      response = Podio.connection.post do |req|
        req.url "/grant/#{ref_type}/#{ref_id}"
        req.body = attributes
      end

      response.body
    end

    # https://hoist.podio.com/api/item/16490748
    def find_own(ref_type, ref_id)
      response = Podio.connection.get("/grant/#{ref_type}/#{ref_id}/own")
      if response.status == 200
        member response.body
      else
        nil
      end
    end

    # https://hoist.podio.com/api/item/16491464
    def find_all(ref_type, ref_id)
      list Podio.connection.get("grant/#{ref_type}/#{ref_id}/").body
    end

    # https://hoist.podio.com/api/item/16496711
    def delete(ref_type, ref_id, user_id)
      Podio.connection.delete("grant/#{ref_type}/#{ref_id}/#{user_id}").body
    end

    # https://hoist.podio.com/api/item/19275931
    def count_by_reference(ref_type, ref_id)
      Podio.connection.get("/grant/#{ref_type}/#{ref_id}/count").body['count']
    end

    # https://hoist.podio.com/api/item/19389786
    def find_for_user_on_space(space_id, user_id)
      list Podio.connection.get("/grant/space/#{space_id}/user/#{user_id}/").body
    end

    # https://hoist.podio.com/api/item/22330891
    def find_own_on_org(org_id)
      list Podio.connection.get("/grant/org/#{org_id}/own/").body
    end

  end
end
