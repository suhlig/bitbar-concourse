# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: [:rubocop, :'spec:all']

namespace :spec do
  desc 'Run all specs'
  task all: %i[unit integration]

  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/unit/**/*_spec.rb'
  end

  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = 'spec/integration/**/*_spec.rb'
  end
end
