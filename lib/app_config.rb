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
      base_config = discover_config(config_name)
      return unless base_config

      config.deep_merge! base_config
      config.deep_merge! discover_local_config(config_name)
      config.deep_merge! discover_env_config(config_name)

      config = IceNine.deep_freeze config
      @config[config_name] = config
    end

    def discover_config(config_name)
      config_file = File.join(CONFIG, "#{config_name}.yml")
      File.exists?(config_file) ? YAML.load_file(config_file) : nil
    end

    def discover_local_config(config_name)
      config_local_file = File.join(CONFIG_LOCAL, "#{config_name}.yml")
      File.exists?(config_local_file) ? YAML.load_file(config_local_file) : {}
    end

    def discover_env_config(config_name)
      config = {}
      ENV.each do |key, value|
        if key.start_with? "#{config_name}-"
          env_hash = generate_hash_from_key(key, value)
          config.deep_merge! env_hash[config_name.to_s]
        end
      end
      config
    end

    def generate_hash_from_key(key, val)
      keys = key.split('-')
      hash = {}
      working_hash = hash
      last_index = keys.length - 1
      keys.each_with_index do |key_name, i|
        i == last_index ? working_hash[key_name] = val : working_hash[key_name] = {}
        working_hash = working_hash[key_name]
      end
      hash
    end
  end
end
