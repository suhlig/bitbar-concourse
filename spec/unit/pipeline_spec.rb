# frozen_string_literal: true

require 'spec_helper'
require 'json'

module Concourse
  describe Pipeline do
    subject(:pipeline) { Pipeline.new(client, bits_service_json) }

    let(:client) do
      double(Client)
    end

    let(:fixtures) do
      Pathname(__dir__).parent / 'fixtures'
    end

    let(:bits_service_json) do
      JSON.parse File.read(fixtures / 'pipelines/bits-service.json')
    end

    before do
      allow(client).to receive(:url).and_return('http://example.com')
      allow(client).to receive(:get).with('/bits-service/jobs').and_return(
        File.read(fixtures / 'pipelines/bits-service/jobs.json')
      )
      allow(client).to receive(:get).with('/bits-service/jobs/CATs-with-bits/builds').and_return(
        File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits/builds.json')
      )
    end

    it 'returns a valid pipeline' do
      expect(pipeline).to be
    end

    it 'has a name' do
      expect(pipeline.name).to eq('bits-service')
    end

    xit 'has a URL' do
      expect(pipeline.url.to_s).to eq('http://example.com/pipelines/bits-service')
    end

    it 'has jobs' do
      jobs = pipeline.jobs
      expect(jobs).to_not be_empty
      expect(jobs.size).to eq(9)
    end

    context 'the first job' do
      let(:job) { pipeline.jobs.first }

      it 'exists' do
        expect(job).to be
      end

      it 'has a name' do
        expect(job.name).to eq('run-tests')
      end

      xit 'belongs to a group' do
        expect(job.group).to eq('bits-service')
      end
    end

    context 'job #7' do
      let(:job) { pipeline.jobs[7] }

      it 'exists' do
        expect(job).to be
      end

      it 'has a name' do
        expect(job.name).to eq('CATs-with-bits')
      end

      xit 'belongs to a group' do
        expect(job.group).to eq('cf-release')
      end

      context 'builds' do
        let(:builds) { job.builds }

        it 'has some' do
          expect(builds).to_not be_empty
        end

        it 'has the expected number of them' do
          expect(builds.size).to eq(12)
        end

        context 'build #9' do
          let(:build) { builds[9] }

          it 'exists' do
            expect(build).to be
          end

          it 'has a name' do
            expect(build.name).to eq('3')
          end
        end
      end
    end

    describe 'the next build has no start time yet' do
      before do
        allow(client).to receive(:get).with('/bits-service/jobs/').and_return(
          File.read(fixtures / 'pipelines/bits-service/jobs/next_build_no_start_time.json')
        )
      end

      it 'has the expected number of jobs' do
        pipeline = Pipeline.new(client, bits_service_json)
        jobs = pipeline.jobs
        expect(jobs).to_not be_empty
        expect(jobs.size).to eq(9)
      end
    end
  end
end
