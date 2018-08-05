# frozen_string_literal: true

require 'rspec'
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'concourse'
require 'cgi'

module Concourse
  describe Client do
    subject(:client) { Concourse::Client.new(concourse_uri, username: username, password: password) }
    let(:username) { nil }
    let(:password) { nil }

    context 'anonymously' do
      let(:concourse_uri) { 'https://ci.concourse-ci.org' }
      let(:pipeline) { 'main' }

      it 'retrieves the list of pipelines' do
        pipelines = client.get("pipelines/#{pipeline}")

        expect(pipelines).not_to be_empty
        expect(JSON.parse(pipelines)).to_not be_empty
      end
    end

    context 'authenticated' do
      let(:concourse_uri) { ENV['CONCOURSE_URI'] }
      let(:pipeline) { CGI.escape(ENV['CONCOURSE_PIPELINE'].to_s) }

      before do
        skip 'CONCOURSE_URI not set' if concourse_uri.to_s.empty?
        skip 'CONCOURSE_PIPELINE not set' if pipeline.to_s.empty?
      end

      context 'correct username and password' do
        let(:username) { ENV['CONCOURSE_USER'] }
        let(:password) { ENV['CONCOURSE_PASSWORD'] }

        before do
          skip 'CONCOURSE_USER not set' if username.to_s.empty?
          skip 'CONCOURSE_PASSWORD not set' if password.to_s.empty?
        end

        it 'retrieves the list of pipelines' do
          pipelines = client.get("pipelines/#{pipeline}")

          expect(pipelines).not_to be_empty
          expect(JSON.parse(pipelines)).to_not be_empty
        end

        context 'expired OAuth token' do
          before do
            client.instance_variable_set('@bearer_token'.to_sym, 'expired')
          end

          it 're-authenticates and succeeds' do
            expect(client.get("pipelines/#{pipeline}")).not_to be_empty
          end
        end
      end

      context 'wrong password' do
        let(:password) { 'some-username' }
        let(:password) { 'some-password' }

        it 'fails to authenticate' do
          expect { client.get("pipelines/#{pipeline}") }.to raise_error(OpenURI::HTTPError, '401 Unauthorized')
        end
      end
    end
  end
end
