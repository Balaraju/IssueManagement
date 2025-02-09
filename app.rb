require 'sinatra'
require 'octokit'
require 'json'
require 'dotenv/load'
require 'openssl'
require 'jwt'
require 'smee'

set :port, 3000

# Method to authenticate and obtain a GitHub client
def github_client
  private_pem = File.read(ENV['GITHUB_PRIVATE_KEY_PATH'])
  app_id = ENV['GITHUB_APP_IDENTIFIER']

  jwt_payload = {
    iat: Time.now.to_i,
    exp: Time.now.to_i + (10 * 60),  # Token expiry of 10 minutes
    iss: app_id
  }

  jwt = JWT.encode(jwt_payload, OpenSSL::PKey::RSA.new(private_pem), 'RS256')

  client = Octokit::Client.new(bearer_token: jwt)
  installation_id = client.find_app_installation(ENV['GITHUB_REPOSITORY']).id

  access_token = client.create_app_installation_access_token(installation_id).token
  Octokit::Client.new(access_token: access_token)
end

# Handle incoming webhook
post '/payload' do
  request.body.rewind
  payload = JSON.parse(request.body.read)

  if payload['action'] == 'opened'
    issue_body = payload['issue']['body']
    issue_number = payload['issue']['number']
    repo = payload['repository']['full_name']

    unless issue_body.match?(/Estimate: \d+ days/)
      github_client.add_comment(repo, issue_number, "Please provide an estimate in the format 'Estimate: X days'.")
    end
  end

  status 200
end

# Start Smee client to forward GitHub webhooks to localhost
SmeeClient.new(source: ENV['SMEE_URL'], target: 'http://localhost:3000/payload').start