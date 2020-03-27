module LogHelpers
  def obfuscate_sensitive_info(input_hash)
    input_hash.each do |key, value|
      input_hash[key] = 'CORONAGO_FILTERED' if ['auth_token', 'password', 'mobile'].include?(key.to_s)
    end
    input_hash
  end
end