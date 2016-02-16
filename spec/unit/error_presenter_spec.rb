require 'spec_helper'

module Bitbar
  module Concourse
    describe ErrorPresenter do
      subject {
        ErrorPresenter.new(error, name)
      }

      context 'when there is an error' do
        let(:error){double(StandardError)}
        let(:name){double('testing')}

        describe '#to_s' do
          it 'returns the error message' do
            allow(error).to receive(:message).and_return('some error message')
            expect(subject.to_s).to include('some error message')
          end
        end
      end
    end
  end
end
