class AppConfig
  CONFIG = File.join(Rails.root, 'config')
  CONFIG_LOCAL = File.join(CONFIG, 'local')

  class << self

    def method_missing(method_name, *args, &block)
      load_config(method_name) || super
    end

    private

    def load_config(config_name)
      @config ||= {}
      return @config[config_name] if @config.has_key? config_name

      config = Hashie::Mash.new

      config_file = File.join(CONFIG, "#{config_name}.yml")
      File.exists?(config_file) ? config.merge!(YAML.load_file(config_file)) : return

      config_local_file = File.join(CONFIG_LOCAL, "#{config_name}.yml")
      config.deep_merge! YAML.load_file(config_local_file) if File.exists? config_local_file

      config = IceNine.deep_freeze config
      @config[config_name] = config
    end
  end
end
