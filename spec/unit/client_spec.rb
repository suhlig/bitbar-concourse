require 'spec_helper'

module Concourse
  describe Client do
    job_json = <<-JSON
      {
        "url": "/some/job/url",
        "finished_build": {
          "id": 928,
          "name": "finished",
          "status": "%s",
          "job_name": "atc",
          "url": "/finished-build"
        },
        "next_build": {
          "id": 929,
          "name": "next",
          "status": "%s",
          "job_name": "atc",
          "url": "/next-build"
        }
      }
    JSON

    before do
      [
        %w(succeeded pending),
        %w(succeeded started),
        %w(failed pending),
        %w(failed started),
        %w(errored pending),
        %w(errored started),
        %w(aborted pending),
        %w(aborted started)
      ].each do |finished_status, next_status|
        WebMock.stub_request(:get, "http://server.example.com/api/v1/teams/main/pipelines/some-pipeline/jobs/#{finished_status}-#{next_status}")
               .to_return(status: 200, body: job_json % [finished_status, next_status], headers: {})
      end

      WebMock.stub_request(:get, "http://server.example.com/auth/basic/token?team_name=main")
             .to_return(status: 200, body: '{}')
    end

    subject do
      Client.new('http://server.example.com/', username: 'username77', password: 'passw0rd')
    end

    context 'when the pipeline and job exist' do
      it 'contains a finished job that has succeeded' do
        expect_finished_job_status('succeeded', 'pending')
      end

      it 'contains a next job that is pending' do
        expect_next_job_status('succeeded', 'pending')
      end

      it 'contains a finished job that has succeeded' do
        expect_finished_job_status('succeeded', 'started')
      end

      it 'contains a next job that is started' do
        expect_next_job_status('succeeded', 'started')
      end

      it 'contains a finished job that has failed' do
        expect_finished_job_status('failed', 'pending')
      end

      it 'contains a next job that is pending' do
        expect_next_job_status('failed', 'pending')
      end

      it 'contains a finished job that has errored' do
        expect_finished_job_status('errored', 'pending')
      end

      it 'contains a next job that is pending' do
        expect_finished_job_status('errored', 'pending')
      end

      it 'contains a finished job that has aborted' do
        expect_finished_job_status('aborted', 'pending')
      end

      it 'contains a next job that is pending' do
        expect_next_job_status('aborted', 'pending')
      end

      it 'contains a finished job that has failed' do
        expect_finished_job_status('failed', 'started')
      end

      it 'contains a next job that is started' do
        expect_next_job_status('failed', 'started')
      end

      it 'contains a finished job that has errored' do
        expect_finished_job_status('errored', 'started')
      end

      it 'contains a next job that is started' do
        expect_next_job_status('errored', 'started')
      end

      it 'contains a finished job that has aborted' do
        expect_finished_job_status('aborted', 'started')
      end

      it 'contains a finished job that is started' do
        expect_next_job_status('aborted', 'started')
      end

      it 'contains a finished job that has succeeded' do
        expect_finished_job_status('succeeded', 'pending')
      end

      it 'contains a next job that is pending' do
        expect_next_job_status('succeeded', 'pending')
      end

      it 'contains a finished job that has failed' do
        expect_finished_job_status('failed', 'pending')
      end

      it 'contains a next job that is pending' do
        expect_next_job_status('failed', 'pending')
      end

      it 'contains a finished job that has errored' do
        expect_finished_job_status('errored', 'pending')
      end

      it 'contains a next job that is pending' do
        expect_next_job_status('errored', 'pending')
      end

      it 'contains a finished job that has succeeded' do
        expect_finished_job_status('succeeded', 'started')
      end

      it 'contains a finished job that is started' do
        expect_next_job_status('succeeded', 'started')
      end

      it 'contains a finished job that has failed' do
        expect_finished_job_status('failed', 'started')
      end

      it 'contains a next job that is started' do
        expect_next_job_status('failed', 'started')
      end

      it 'contains a finished job that has errored' do
        expect_finished_job_status('errored', 'started')
      end

      it 'contains a next job that is started' do
        expect_next_job_status('errored', 'started')
      end

      def expect_finished_job_status(finished_status, next_status)
        response = subject.get("/pipelines/some-pipeline/jobs/#{finished_status}-#{next_status}")
        expect(response).to_not be_empty

        builds = JSON.parse(response)
        expect(builds).to_not be_empty

        build = builds['finished_build']
        expect(build).to_not be_nil

        status = build['status']
        expect(status).to eq(finished_status)
      end

      def expect_next_job_status(finished_status, next_status)
        response = subject.get("/pipelines/some-pipeline/jobs/#{finished_status}-#{next_status}")
        expect(response).to_not be_empty

        builds = JSON.parse(response)
        expect(builds).to_not be_empty

        build = builds['next_build']
        expect(build).to_not be_nil

        status = build['status']
        expect(status).to eq(next_status)
      end
    end
  end
end
