# TODO:
# 1 Create custom error handling class or classes and implement
# 2 Refactor reppetetive HTTParty calls
# 3 Create before and after hooks similar to Rails for token_validation and 
# response parsing

require 'todoable/version'
require 'httparty'

module Todoable
  HOST = 'http://todoable.teachable.tech/api'

  class Lists
    attr_accessor :auth
    def initialize
      authorize
    end

    def index
      res = validate_token do
        HTTParty.get(
          "#{HOST}/lists",
          headers: authorized_headers
        )
      end
      parse_response(res)
    end

    def create(params)
      res = validate_token do
        HTTParty.post(
          "#{HOST}/lists",
          headers: authorized_headers,
          body: {list: params[:list]}.to_json
        )
      end
      parse_response(res)
    end

    def get_list(params)
      res = validate_token do
        HTTParty.get(
          "#{HOST}/lists/#{params[:id]}",
          headers: authorized_headers
        )
      end
      parse_response(res)
    end

    def update(params)
      res = validate_token do
        HTTParty.patch(
          "#{HOST}/lists/#{params[:id]}",
          headers: authorized_headers,
          body: {list: params[:list]}.to_json
        )
      end
      parse_response(res)
    end

    def delete(params)
      res = validate_token do
        HTTParty.delete(
          "#{HOST}/lists/#{params[:id]}",
          headers: authorized_headers
        )
      end
      parse_response(res)
    end

    def create_item(params)
      res = validate_token do
        HTTParty.post(
          "#{HOST}/lists/#{params[:id]}/items",
          headers: authorized_headers,
          body: { item: params[:item] }.to_json
        )
      end
      parse_response(res)
    end

    def finish_item(params)
      res = validate_token do
        HTTParty.put(
          "#{HOST}/lists/#{params[:id]}/items/#{params[:item_id]}/finish",
          headers: authorized_headers
        )
      end
      parse_response(res)
    end

    def delete_item(params)
      res = validate_token do
        HTTParty.delete(
          "#{HOST}/lists/#{params[:id]}/items/#{params[:item_id]}",
          headers: authorized_headers
        )
      end
      parse_response(res)
    end

    private

    def authorize
      @auth = HTTParty.post(
        "#{HOST}/authenticate",
        basic_auth:{username: ENV['TODOABLE_USERNAME'], password: ENV['TODOABLE_PASSWORD']},
        headers: {'Content-Type' => 'application/json'}
      )
      raise "#{@auth.msg}! Username or password must be wrong" if @auth.code == 401
    end

    def authorized_headers
      {
        'Authorization': auth['token'],
        'Content-Type' => 'application/json'
      }
    end

    def validate_token
      if Time.now.getutc < Time.parse(auth['expires_at'])
        yield
      else
        authorize
        yield
      end
    end

    def parse_response(res)
      if res.code == 200
        res["description"] = "OK: The data you requested is in the body."
        res
      else
        {}.tap do |response|
          response["body"] = res
          response["description"] = {
            201 => "Created: Use the Location header to find the thing you just created.",
            204 => "No Content: Mostly used to signal that the thing has been deleted.",
            401 => "Unauthorized: You didn't provide the right token, or it expired.",
            422 => "Unprocessable Entity: The data you submitted are semantically incorrect. The errors are in the body."
          }[res.code]
          response
        end
      end
    end

  end
end