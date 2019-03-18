RSpec.describe Todoable::Lists do
  describe "gem authorizes itself based on username and password stored in env variables" do
    it "successfuly authorizes a user and responds with auth token" do
      VCR.use_cassette('auth_success') do
        lists = Todoable::Lists.new
        expect(lists.auth['token'].class).to be String
      end
    end

    it "raises error if password or username are incorrect" do
      VCR.use_cassette('auth_failure') do
        ENV['TODOABLE_PASSWORD'] = "somepassword"
        expect{Todoable::Lists.new}.to raise_error(RuntimeError)
      end
    end
  end 
end
