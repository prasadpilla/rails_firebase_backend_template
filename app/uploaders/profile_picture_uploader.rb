# Handles image uploads for profile pictures
class ProfilePictureUploader < ImageUploader

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    'profile-pictures/'
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
    ActionController::Base.helpers.asset_path([version_name, 'default-profile-picture.jpg'].compact.join('_'))
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [50, 50]
  end
end
