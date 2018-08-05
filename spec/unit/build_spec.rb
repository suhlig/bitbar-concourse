# frozen_string_literal: true

require 'spec_helper'
require 'json'

module Concourse
  describe Build do
    subject { Build.new(job, build_json) }

    let(:job) do
      double(Job)
    end

    let(:fixtures) do
      Pathname(__dir__).parent / 'fixtures'
    end

    let(:build_json) do
      JSON.parse File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits/builds/12.json')
    end

    describe 'a fresh build' do
      it 'returns a valid build' do
        allow(job).to receive(:url).and_return('')

        expect(subject).to_not be_nil
        expect(subject.name).to eq('12')

        expect(subject.status).to eq('succeeded')
        expect(subject.url).to eq('/pipelines/bits-service/jobs/CATs-with-bits/builds/12')
        expect(subject.start_time.to_s).to eq('2016-02-12 17:36:55 +0100')
        expect(subject.end_time.to_s).to eq('2016-02-12 17:54:49 +0100')
      end

      it 'has does not have a next build' do
        allow(job).to receive(:next_build)
        expect(subject.next).to be_nil
      end
    end

    describe 'a build with successor' do
      it 'has a next build' do
        allow(job).to receive(:next_build).and_return(double(Build))
        expect(subject.next).to be
      end
    end
  end
end
