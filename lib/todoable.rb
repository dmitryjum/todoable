require 'todoable/version'
require 'httparty'

module Todoable
  HOST = 'http://todoable.teachable.tech/api'

  class Lists
    attr_reader :auth
    def initialize
      @username = ENV['TODOABLE_USERNAME']
      @password = ENV['TODOABLE_PASSWORD']
      @auth = authorize
    end

    def index
      HTTParty.get(
        "#{HOST}/lists",
        headers: {
          'Authorization': @auth['token'],
          'Content-Type' => 'application/json'
        }
      )
    end

    def create(params)
      HTTParty.post(
        "#{HOST}/lists",
        headers: {
          'Authorization': @auth['token'],
          'Content-Type' => 'application/json'
        },
        body: { list: params }.to_json
      )
    end

    def get_list(params)
      HTTParty.get(
        "#{HOST}/lists/#{params[:id]}",
        headers: {
          'Authorization': @auth['token'],
          'Content-Type' => 'application/json'
        }
      )
    end

    def update(params)
    end

    def delete(params)
    end

    def create_item(params)
    end

    def finish_item(params)
    end

    def delete_item(params)
    end

    private

    def authorize
      HTTParty.post(
        "#{HOST}/authenticate",
        basic_auth:{username: @username, password: @password},
        headers: {'Content-Type' => 'application/json'}
      )
    end
  end
end

 # def self.expired(payload)
 #    Time.at(payload['exp']) < Time.now
 #  end


# HTTParty.post(
#   'https://us12.api.mailchimp.com/3.0/lists/17efad7sde/merge-fields', 
#   basic_auth: { username: '12', password: 'd1c1d99dr5000c63f0f73f64b88e852e-xx' },
#   headers: { 'Content-Type' => 'application/json' },
#   body: {
#     name: 'FAVORITEJOKE',
#     type: 'text',
#   }.to_json
# )