class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :mobile, :profile_picture_url, :wallet_balance

  def profile_picture_url
    if object.profile_picture_url.include?('default-profile-picture')
      ''
    else
      object.profile_picture_url
    end
  end
end
