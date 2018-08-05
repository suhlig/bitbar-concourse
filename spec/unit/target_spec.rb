# frozen_string_literal: true

require 'spec_helper'

module Concourse
  describe Target do
    let(:api) { 'http://10.155.248.166:8080' }
    let(:user) { 'admin' }
    let(:password) { 'admin' }
    let(:client) do
      double(Client)
    end

    subject do
      Target.new(client)
    end

    context 'when target is available' do
      before do
        fixture = Pathname(__dir__).parent / 'fixtures/pipelines/bits-service.json'
        allow(client).to receive(:get).and_return(File.read(fixture))
      end

      describe '#pipelines' do
        it 'returns multiple pipelines' do
          expect(subject.pipelines).to_not be_empty
        end
      end
    end
  end
end
