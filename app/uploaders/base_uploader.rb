class BaseUploader < CarrierWave::Uploader::Base

  # Choose what kind of storage to use for this uploader:
  storage Rails.env.production? ? :aws : :file

  # Generate a unique file name with a combination of uuid and first_name
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
