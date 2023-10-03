class ImportCollection < ApplicationService
  require 'rake'
  attr_reader :upload, :current_user, :request

  def initialize(upload, current_user, request)
    @upload = upload
    @current_user = current_user
    @request = request
  end

  def call
    #Save file to local dir
    filename = @upload.original_filename
    filename_with_path = Rails.root.join('public', 'tmp', filename)
    File.open(filename_with_path, 'wb') do |file|
      file.write(@upload.read)
    end

    Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
    CrystalData::Application.load_tasks 
    Rake::Task['tables:import'].invoke(filename_with_path, filename, @current_user.id, request.remote_ip)
  end
end