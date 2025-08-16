require 'erb'
require 'fileutils'

class WebAppGenerator
  attr_reader :app_name, :template_folder

  def initialize(app_name, template_folder)
    @app_name = app_name
    @template_folder = template_folder
  end

  def generate
    create_app_folder
    create_gemfile
    create_config_files
    create_app_files
  end

  private

  def create_app_folder
    FileUtils.mkdir_p(app_name)
  end

  def create_gemfile
    template = File.read("#{template_folder}/Gemfile.erb")
    renderer = ERB.new(template)
    gemfile_content = renderer.result(binding)
    File.write("#{app_name}/Gemfile", gemfile_content)
  end

  def create_config_files
    %w(application.rb environment.rb).each do |filename|
      template = File.read("#{template_folder}/config/#{filename}.erb")
      renderer = ERB.new(template)
      config_content = renderer.result(binding)
      File.write("#{app_name}/config/#{filename}", config_content)
    end
  end

  def create_app_files
    %w(app helpers models controllers views).each do |folder|
      FileUtils.mkdir_p("#{app_name}/#{folder}")
    end
  end
end

# Test case
generator = WebAppGenerator.new('my_app', 'templates')
generator.generate