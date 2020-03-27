class ImageUploader < BaseUploader

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w[jpg jpeg gif png].freeze
  end
end
