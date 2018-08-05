# frozen_string_literal: true

require 'spec_helper'
require 'json'

module Concourse
  describe Job do
    let(:pipeline) do
      double(Pipeline)
    end

    let(:fixtures) do
      Pathname(__dir__).parent / 'fixtures'
    end

    let(:job_json) do
      JSON.parse File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits.json')
    end

    before do
      allow(pipeline).to receive(:url).and_return('http://example.com')
      allow(pipeline).to receive(:get).with('/CATs-with-bits').and_return(
        File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits.json')
      )
      allow(pipeline).to receive(:get).with('/CATs-with-bits/builds').and_return(
        File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits/builds.json')
      )
    end

    describe '#new' do
      it 'returns a valid job' do
        job = Job.new(pipeline, job_json)
        expect(job).to_not be_nil
        expect(job.name).to eq('CATs-with-bits')

        # TODO
        # expect(job.group).to eq('bits-service')

        builds = job.builds
        expect(builds).to_not be_empty
        expect(builds.size).to eq(12)

        build_9 = builds[9]
        expect(build_9).to_not be_nil
        expect(build_9.name).to eq('3')
      end

      context 'latest job is in started state' do
        let(:job_json) do
          JSON.parse File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits.json')
        end

        it 'has a latest finished build' do
          job = Job.new(pipeline, job_json)
          expect(job.finished_build).to be
          expect(job.finished_build.finished?).to be(true)
        end
      end
    end
  end
end
