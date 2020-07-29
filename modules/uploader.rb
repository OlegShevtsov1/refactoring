# frozen_string_literal: true

module Uploader
  STORE = 'accounts.yml'

  def loads
    YAML.load_file(STORE) if FileTest.file?(STORE)
  end

  def save(entities)
    File.open(STORE, 'w') { |f| f.write entities.to_yaml }
  end
end
