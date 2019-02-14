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

    context 'a fresh build' do
      before { allow(job).to receive(:url).and_return('') }

      it 'returns a valid build' do
        expect(subject).to_not be_nil
      end

      it 'has a name' do
        expect(subject.name).to eq('12')
      end

      it 'has a status' do
        expect(subject.status).to eq('succeeded')
      end

      it 'has a fully qualified URL' do
        expect(subject.url).to eq('/api/v1/builds/480')
      end

      it 'has a start time' do
        expect(subject.start_time).to eq(Time.new(2016, 2, 12, 17, 36, 55, '+01:00'))
      end

      it 'has an end time' do
        expect(subject.end_time).to eq(Time.new(2016, 2, 12, 17, 54, 49, '+01:00'))
      end

      context 'there is no successor' do
        before { allow(job).to receive(:next_build) }

        it 'has does not have a next build' do
          expect(subject.next).to be_nil
        end
      end
    end

    context 'a build with successor' do
      before { allow(job).to receive(:next_build).and_return(double(Build)) }

      it 'has a next build' do
        expect(subject.next).to be
      end
    end
  end
end
