# frozen_string_literal: true

require 'spec_helper'

module Bitbar
  module Concourse
    describe BuildPresenter do
      subject(:presented_build) do
        BuildPresenter.new(build)
      end

      context 'when build time is below a minute' do
        let(:build) do
          b = Object.new
          allow(b).to receive(:start_time).and_return(Time.at(23))
          allow(b).to receive(:end_time).and_return(Time.at(42))
          b
        end

        describe '#elapsed_time' do
          it 'returns seconds as is' do
            expect(presented_build.elapsed_time).to eq('19 seconds')
          end
        end
      end

      context 'when build time is exactly one minute' do
        let(:build) do
          b = Object.new
          allow(b).to receive(:start_time).and_return(Time.at(123))
          allow(b).to receive(:end_time).and_return(Time.at(183))
          b
        end

        describe '#elapsed_time' do
          it 'returns seconds as is' do
            expect(presented_build.elapsed_time).to eq('one minute')
          end
        end
      end

      context 'when the build finished yesterday' do
        let(:build) do
          double(::Concourse::Build).tap do |b|
            allow(b).to receive(:start_time).and_return(Time.at(23))
            allow(b).to receive(:end_time).and_return(Time.at(42))
            allow(b).to receive(:success?).and_return(true)
            allow(b).to receive(:job_name).and_return('test_job')
            allow(b).to receive(:name).and_return('test_build')
            allow(b).to receive(:url).and_return('http://example.com/')
            allow(b).to receive(:next).and_return(nil)
          end
        end

        it 'presents the relative end time' do
          expect(presented_build.to_s).to include('19 seconds')
        end
      end

      context 'next build has no start time' do
        let(:job_info) { JSON.parse(File.read(Pathname(__dir__).parent / 'fixtures/builds/no_start_time.json')) }

        let(:job) do
          double(::Concourse::Job).tap do |job|
            allow(job).to receive(:next_build) do
              double(::Concourse::Build).tap do |build|
                allow(build).to receive(:start_time).and_return(nil)
                allow(build).to receive(:name).and_return('test')
                allow(build).to receive(:url).and_return('http://ci.example.com')
              end
            end
          end
        end

        let(:build) { ::Concourse::Build.new(job, job_info) }

        it 'fails' do
          expect(presented_build.to_s).to include('started not yet')
        end
      end
    end
  end
end
