require "google/api_client"
require "google/api_client/client_secrets"

module Mirror
  class Client
    APPLICATION_NAME = "Mirror Sample Application"
    APPLICATION_VERSION = "0.1"
    SCOPES = %w(
      https://www.googleapis.com/auth/glass.timeline
      https://www.googleapis.com/auth/glass.location
      https://www.googleapis.com/auth/userinfo.profile
    ).freeze

    def initialize(attrs = {})
      @client = Google::APIClient.new(
        application_name: APPLICATION_NAME,
        application_version: APPLICATION_VERSION
      )
      @client.authorization = secrets
      @client.authorization.scope = SCOPES
      @client.authorization.access_token = attrs[:access_token]
      @mirror = @client.discovered_api("mirror", "v1")
    end

    def insert_card(card)
      method = @mirror.timeline.insert
      timeline_item = method.request_schema.new(card.to_item)
      @client.execute!(api_method: method, body_object: timeline_item)
    end

    def authorization_url(user_id: nil, state: nil)
      @client.authorization.authorization_uri(
        approval_prompt: :force,
        access_type: :offline,
        user_id: user_id,
        state: state
      ).to_s
    end

    def exchange_code_for_access_token(code)
      @client.authorization.code = code
      @client.authorization.fetch_access_token!
      @client.authorization.access_token
    end

    def userinfo
      oauth2 = @client.discovered_api("oauth2", "v2")
      result = @client.execute!(api_method: oauth2.userinfo.get)
      result.data
    end

    private

    def secrets
      secrets_path = Mirror.root.join("config/secrets.json")
      if secrets_path.exist?
        Google::APIClient::ClientSecrets.load(secrets_path.to_s).to_authorization
      else
        nil
      end
    end
  end
end
