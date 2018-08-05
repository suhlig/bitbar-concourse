# frozen_string_literal: true

require 'spec_helper'

module Bitbar
  module Concourse
    describe AggregatePresenter do
      let(:build_green) do
        double(::Concourse::Build)
      end

      let(:build_red) do
        double(::Concourse::Build)
      end

      before do
        allow(build_green).to receive(:success?).and_return(true)
        allow(build_red).to receive(:success?).and_return(false)
      end

      context 'when all builds are green' do
        subject do
          AggregatePresenter.new([build_green, build_green])
        end

        describe '#to_s' do
          it 'presents the aggregate as green' do
            expect(subject.to_s).to include('color=green')
          end
        end

        describe '#success?' do
          it 'is true' do
            expect(subject.success?).to be true
          end
        end
      end

      context 'when a job has a failing build' do
        subject do
          AggregatePresenter.new([build_green, build_red])
        end

        describe '#to_s' do
          it 'presents the aggregate as red' do
            expect(subject.to_s).to include('color=red')
          end
        end

        describe '#success?' do
          it 'is false' do
            expect(subject.success?).to be false
          end
        end
      end

      context 'when all jobs are red' do
        subject do
          AggregatePresenter.new([build_red, build_red])
        end

        describe '#to_s' do
          it 'presents the aggregate as red' do
            expect(subject.to_s).to include('color=red')
          end
        end

        describe '#success?' do
          it 'is false' do
            expect(subject.success?).to be false
          end
        end
      end
    end
  end
end
