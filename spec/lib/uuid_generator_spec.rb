require "uuid_generator"

describe "uuid_generator" do
    UUID_REGEX = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/

    it "generates a uuid" do
        expect(UUIDGenerator.new.generate_uuid).to match(UUID_REGEX)
    end
end