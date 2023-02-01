require 'securerandom'

class UUIDGenerator
    # Generates a UUID that will be set as the id of the processed receipt
    def generate_uuid
        @uuid = SecureRandom.uuid
    end
end