require 'pivotal-tracker'

module PivotalCli
  class Tracker
    attr_accessor :project, :username

    def config_file
      @config_file ||= "#{ENV['HOME']}/.pivotal"
    end

    def setup_complete?
      File.exists?(config_file)
    end

    def setup(username, project_id, token)
      username = username.strip
      File.open(config_file, 'w') do |file|
        file.puts(username)
        file.puts(project_id)
        file.puts(token)
      end
    end

    def my_stories
      @project.stories.all(owned_by: username).reject { |s| s.current_state =~ /accepted/ }
    end

    def create_story(name, description)
      attributes = {
          story_type: 'feature',
          name: name,
          description: description,
          owned_by: username
      }
      @project.stories.create(attributes)
    end

    def set_points(story, points)
      story.update(estimate: points)
    end

    def start(story)
      story.update(current_state: 'started')
    end

    def load_configuration
      File.open(config_file, 'r') do |file|
        lines = file.readlines
        @username  = lines[0].strip
        token      = lines[2].strip
        project_id = lines[1].strip

        PivotalTracker::Client.token = token
        PivotalTracker::Client.use_ssl = true
        @project = PivotalTracker::Project.find(project_id)
      end
    end
  end
end
