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
        cached_password = ENV['TODOABLE_PASSWORD']
        ENV['TODOABLE_PASSWORD'] = "somepassword"
        expect{Todoable::Lists.new}.to raise_error(RuntimeError)
        ENV['TODOABLE_PASSWORD'] = cached_password
      end
    end
  end

  describe "checks that token is valid" do
    it "reauthorizes the instance if the token expired on any given method" do
      VCR.use_cassette('reauthorize') do
        lists = Todoable::Lists.new
        some_date = "2018-03-18T01:21:39.747Z"
        lists.auth["expires_at"] = some_date
        lists.index
        expect(Time.parse(lists.auth["expires_at"]) > Time.parse(some_date)).to be true
      end
    end

    it "responds with error message if the token is invalid calling any given method" do
      VCR.use_cassette('invalid_token') do
        lists = Todoable::Lists.new
        lists.auth["token"] = 'some_token'
        response = lists.index
        expect(response["body"].code).to be 401
        expect(response["description"]).to eq "Unauthorized: You didn't provide the right token, or it expired."
      end
    end
  end

  describe "instance methods" do
    context "#index" do
      it "returns lists" do
        VCR.use_cassette('index_lists_success') do
          lists = Todoable::Lists.new
          expect(lists.index['lists'].class).to be Array
        end
      end
    end

    context "#create" do
      it "fails to create a list because of possible validation errors" do
        VCR.use_cassette('create_list_failure') do
          lists = Todoable::Lists.new
          response = lists.create({list: {name: "Test List"}})
          expect(response["body"]["name"].class).to be Array
          expect(response["description"]).to eq "Unprocessable Entity: The data you submitted are semantically incorrect. The errors are in the body."
        end
      end

      it "successfuly creates a list" do
        VCR.use_cassette('create_list_success') do
          lists = Todoable::Lists.new
          response = lists.create({list: {name: "Third Test List"}})
          expect(response["body"]["name"]).to eq "Third Test List"
          expect(response["description"]).to eq "Created: Use the Location header to find the thing you just created."
        end
      end
    end

    context "#get_list" do
      it "successfuly retrieves a list by id" do
        VCR.use_cassette('gets_a_list') do
          lists = Todoable::Lists.new
          test_list = lists.index["lists"].last
          found_list = lists.get_list({id: test_list['id']})
          expect(found_list['name']).to eq test_list['name']
        end
      end

      it "doesn't find a list by id" do
        VCR.use_cassette('does_not_get_a_list') do
          lists = Todoable::Lists.new
          response = lists.get_list({id: 'some_id'})
          expect(response['body'].code).to be 404
        end
      end
    end

    context "#update" do
      it "successfuly updates a list by id" do
      end

      it "fails to update a list by id" do
      end
    end

    context "#delete" do
      it "successfuly deletes a list by id" do
      end

      it "fails to delete list by id" do
      end
    end

    context "#create_item" do
      it "creates a new item for a list by its id" do
      end

      it "fails to create a new item for a list (validation, or list not found, etc)" do
      end
    end

    context "#finish_item" do
      it "sets the item finished_at attribute" do
      end

      it "fails to finish item" do
      end
    end

    context "#delete_item" do
      it "deletes an item by list and item ids" do
      end

      it "fails to delete an item" do
      end
    end
  end
end
