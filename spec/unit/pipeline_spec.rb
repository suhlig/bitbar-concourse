# frozen_string_literal: true
require 'spec_helper'
require 'json'

module Concourse
  describe Pipeline do
    subject { Pipeline.new(client, bits_service_json) }

    let(:fixtures) do
      Pathname(__dir__).parent / 'fixtures'
    end

    let(:client) do
      double(Client)
    end

    let(:bits_service_json) do
      JSON.parse File.read(fixtures / 'pipelines/bits-service.json')
    end

    before do
      allow(client).to receive(:url).and_return('http://example.com')
      allow(client).to receive(:get).with('/bits-service/jobs').and_return(File.read(fixtures / 'pipelines/bits-service/jobs.json'))
      allow(client).to receive(:get).with('/bits-service/jobs/CATs-with-bits/builds').and_return(File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits/builds.json'))
    end

    describe '#new' do
      it 'returns a valid pipeline' do
        expect(subject).to_not be_nil

        expect(subject.name).to eq('bits-service')
        expect(subject.url.to_s).to eq('http://example.com/pipelines/bits-service')

        jobs = subject.jobs
        expect(jobs).to_not be_empty
        expect(jobs.size).to eq(9)

        job_0 = jobs.first
        expect(job_0).to_not be_nil
        expect(job_0.name).to eq('run-tests')

        # TBD
        # expect(job_0.group).to eq('bits-service')

        job_7 = jobs[7]
        expect(job_7).to_not be_nil
        expect(job_7.name).to eq('CATs-with-bits')
        # TBD
        # expect(job_7.group).to eq('cf-release')

        builds = job_7.builds
        expect(builds).to_not be_empty
        expect(builds.size).to eq(12)

        build_9 = builds[9]
        expect(build_9).to_not be_nil
        expect(build_9.name).to eq('3')
      end
    end

    describe '#to_s' do
      it 'no arg returns the short form' do
        expect(subject.to_s).to eq('pipeline bits-service')
      end

      it ':short returns the short form' do
        expect(subject.to_s(:short)).to eq('pipeline bits-service')
      end

      it ':long returns the long form' do
        allow(client).to receive(:to_s).with(:long).and_return('client something')
        expect(subject.to_s(:long)).to eq('pipeline bits-service of client something')
      end
    end
  end
end
