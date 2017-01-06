require 'waylon/errors'
class Waylon
  module Jenkins
    class Job
      class Memcached < REST

        include Waylon::Jenkins::Memcached

        attr_reader :name
        attr_reader :client

        def initialize(name, server)
          super
          @memcache = @server.memcache
        end

        def job_details
          @job_details ||= cache("job-#{name}-details") { super }
        end

        def est_duration
          @est_duration ||= cache("job-#{name}-est-duration") { super }
        end

        def progress_pct
          @progress_pct ||= cache("job-#{name}-progress-pct") { super }
        end

        def description
          @description ||= cache("job-#{name}-description") { super }
        end

        def last_build_timestamp
          @last_build_timestamp ||= cache("job-#{name}-last-build-timestamp") { super }
        end
      end
    end
  end
end
