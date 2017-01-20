class Waylon
  module Jenkins
    class Job
      require 'waylon/jenkins/job/rest'
      require 'waylon/jenkins/job/memcached' unless !!File::ALT_SEPARATOR

      attr_reader :name
      attr_reader :server

      def initialize(name, server)
        @name   = name
        @server = server
      end
    end
  end
end
