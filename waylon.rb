require 'sinatra'
require 'cgi'
require 'date'
require 'jenkins_api_client'
require 'yaml'
require 'deterministic'
require 'resolv'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')


class Waylon < Sinatra::Application
  require 'waylon/config'
  require 'waylon/jenkins'
  require 'waylon/version'
  include Deterministic

  helpers do
    # Read configuration in from YAML
    def gen_config
      if File.exists?('/etc/waylon.yml')
        config = '/etc/waylon.yml'
      else
        config = File.join(File.dirname(__FILE__), 'config/waylon.yml')
      end

      Waylon::Config::RootConfig.from_hash(YAML.load_file(config))
    end

    # Generate a list of views
    def get_views()
      gen_config.views.map(&:name)
    end

    def manadic(monad)
      if monad.success?
        status 200
        body(JSON.pretty_generate(monad.value))
      elsif monad.value.is_a? Waylon::Errors::NotFound
        status 404
        body(JSON.pretty_generate({"errors" => [monad.value.message]}))
      else
        raise monad.value
      end
    end
  end

  # Print a list of views available on this Waylon instance.
  get '/' do
    @view_name = 'index'

    erb :base do
      erb :index
    end
  end

  # Displays the jobs configured for a particular view.
  get '/view/:name' do
    @view_name = CGI.unescape(params[:name])
    erb :base do
      erb :view
    end
  end

  # API: the name and server URLs of a particular view
  get '/api/view/:view.json' do
    view_name = CGI.unescape(params[:view])

    manadic(Either.attempt_all(self) do
      try { Waylon::Jenkins.view(gen_config, view_name) }
      try { |view| view.to_config }
    end)
  end

  # API: "friendly" names of servers for a particular view
  get '/api/view/:view/servers.json' do
    view_name = CGI.unescape(params[:view])

    manadic(Either.attempt_all(self) do
      try { Waylon::Jenkins.view(gen_config, view_name) }
      try { |view| view.servers.map(&:name) }
    end)
  end

  # API: using the "friendly" name of the server, returns the name,
  # URL, and jobs associated with that server
  get '/api/view/:view/server/:server.json' do
    view_name = CGI.unescape(params[:view])
    server_name = CGI.unescape(params[:server])

    manadic(Either.attempt_all(self) do
      try { Waylon::Jenkins.view(gen_config, view_name) }
      try { |view| view.server(server_name) }
      try { |server| server.to_config }
    end)
  end

  # API: like the above, but returns only a list of jobs
  get '/api/view/:view/server/:server/jobs.json' do
    view_name = CGI.unescape(params[:view])
    server_name = CGI.unescape(params[:server])

    manadic(Either.attempt_all(self) do
      try { gen_config.view(view_name) }
      try { |view| view.server(server_name) }
      try { |server| server.jobs.map(&:name) }
    end)
  end

  get '/api/view/:view/jobs.json' do
    view_name = CGI.unescape(params[:view])

    manadic(Either.attempt_all(self) do
      try { Waylon::Jenkins.view(gen_config, view_name) }
      try { |view| view.jobs }
    end)
  end

  # API: gets job details for a particular job on a particular server
  get '/api/view/:view/server/:server/job/:job.json' do
    view_name   = CGI.unescape(params[:view])
    server_name = CGI.unescape(params[:server])
    job_name    = CGI.unescape(params[:job])

    manadic(Either.attempt_all(self) do
      try { Waylon::Jenkins.view(gen_config, view_name) }
      try { |view| view.server(server_name) }
      try { |server| server.job(job_name) }
      try { |job| job.to_hash }
    end)
  end


  post '/api/view/:view/server/:server/job/:job/describe' do
    view_name   = CGI.unescape(params[:view])
    server_name = CGI.unescape(params[:server])
    job_name    = CGI.unescape(params[:job])
    desc        = CGI.unescape(params[:desc])

    if !(desc.nil? or desc.empty?)
      submitter = begin
                    Resolv.getname(request.ip)
                  rescue Resolv::ResolvError
                    request.ip
                  end

      desc << " by #{submitter}"
    end

    manadic(Either.attempt_all(self) do
      try { Waylon::Jenkins.view(gen_config, view_name) }
      try { |view| view.server(server_name) }
      try { |server| server.job(job_name) }
      try { |job| job.describe_build!(desc) }
    end)
  end
end
