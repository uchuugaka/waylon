require 'fileutils'

# Log location
if File.exists?('/var/log/waylon')
  log_dir = '/var/log/waylon'
else
  log_dir = File.join(File.dirname(__FILE__), '../logs')
  FileUtils.mkdir(log_dir) unless File.exists?(log_dir)
end

stderr_path File.join(log_dir, 'waylon.err')
stdout_path File.join(log_dir, 'waylon.out')

# Number of worker processes to launch.
# Generally speaking, launching two per CPU core is fine.
worker_processes 4

# Timeout, in seconds.
# This should be less than Waylon's `refresh_interval`
timeout 55

