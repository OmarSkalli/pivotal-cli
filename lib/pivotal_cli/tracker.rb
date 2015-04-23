require 'pivotal-tracker'

module PivotalCli
  class Tracker
    attr_accessor :projects, :username

    def config_file
      @config_file ||= "#{ENV['HOME']}/.pivotal"
    end

    def setup_complete?
      File.exists?(config_file)
    end

    def setup(username, project_ids, token)
      username = username.strip
      File.open(config_file, 'w') do |file|
        file.puts(username)
        file.puts(project_ids)
        file.puts(token)
      end
    end

    def my_stories_per_project
      projects.map do |project|
        stories = project.stories.all(owned_by: username).reject { |s| s.current_state =~ /accepted/ }
        [project.id, project.name, stories]
      end
    end

    def find_story(story_id)
      projects.each do |project|
        story = project.stories.find(story_id)
        return story unless story.nil?
      end

      nil
    end

    def create_story(story)
      story.story_type = 'feature'
      story.owned_by = username
      story.create # Return a new story object (with id)
    end

    def set_points(story, points)
      story.update(estimate: points)
    end

    def start(story)
      story.update(current_state: 'started')
    end

    def finish(story)
      story.update(current_state: 'finished')
    end

    def deliver(story)
      story.update(current_state: 'delivered')
    end

    def load_configuration
      File.open(config_file, 'r') do |file|
        lines = file.readlines
        @username   = lines[0].strip
        token       = lines[2].strip
        project_ids = lines[1].split(',').map(&:strip)

        PivotalTracker::Client.token = token
        PivotalTracker::Client.use_ssl = true
        @projects = project_ids.map { |project_id| PivotalTracker::Project.find(project_id) }
      end
    end
  end
end
