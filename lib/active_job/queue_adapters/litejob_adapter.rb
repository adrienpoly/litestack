# frozen_string_literal: true

require_relative '../../litestack/litejob.rb'
require "active_support/core_ext/enumerable"
require "active_support/core_ext/array/access"
require "active_job"

module ActiveJob
  module QueueAdapters
    # == Litestack adapter for Active Job
    #
    #
    #   Rails.application.config.active_job.queue_adapter = :litejob
    class LitejobAdapter
          
      def initialize(options={})
        # we currently don't honour individual options per job class
        # possible in the future?
        # Job.options = DEFAULT_OPTIONS.merge(options)
      end
    
      def enqueue(job) # :nodoc:
        Job.queue = job.queue_name
        Job.perform_async(job.serialize)
      end

      def enqueue_at(job, timestamp) # :nodoc:
        Job.queue = job.queue_name
        Job.perform_at(timestamp, job.serialize)
      end

      class Job # :nodoc:
        
        DEFAULT_OPTIONS = {
          config_path: "./config/litejob.yml",
          logger: nil, # Rails performs its logging already
        }      

        include ::Litejob
  
        def perform(job_data)
          Base.execute job_data
        end
      end
    end
  end
end
