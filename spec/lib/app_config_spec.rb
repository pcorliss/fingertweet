require 'spec_helper'

describe AppConfig do
  before do
    stub_const("AppConfig::CONFIG", 'spec/fixtures/config')
    stub_const("AppConfig::CONFIG_LOCAL", 'spec/fixtures/config/local')
    AppConfig.instance_variable_set :@config, nil
  end

  it "loads all the yaml data from the config directory" do
    expect(AppConfig.foo['bar']).to eq('fubar')
    expect(AppConfig.bar['foo']).to eq('barfoo')
  end

  it "deep merges similarly named files from the config/local directory" do
    expect(AppConfig.defaults['buzz']['cola']).to eq('Tastes Great!')
    expect(AppConfig.defaults['buzz']['beer']).to eq('Less Filling')
  end

  it "raises a method missing error if the file under config doesn't exist" do
    expect do
      AppConfig.nonexistant_config
    end.to raise_error(NoMethodError)
  end

  it "doesn't raise an error if the file under config/local doesn't exist" do
    expect do
      AppConfig.foo
    end.to_not raise_error
  end

  it "returns hashes with indifferent access" do
    expect(AppConfig.defaults[:buzz][:cola]).to eq('Tastes Great!')
  end

  it "is accessible as a dottable hash" do
    expect(AppConfig.defaults.buzz.cola).to eq('Tastes Great!')
  end

  it "caches the results" do
    expect(AppConfig.defaults.buzz.cola).to eq('Tastes Great!')
    YAML.stub(:load_file => {'buzz' => {'cola' => 'Tastes Terrible!'}})
    expect(AppConfig.defaults.buzz.cola).to eq('Tastes Great!')
  end

  it "freezes the results to prevent modification" do
    expect do
      AppConfig.defaults.buzz.cola = 'foo'
    end.to raise_error(RuntimeError, "can't modify frozen Hashie::Mash")
  end

  it "overrides config variables when ENV variables are present" do
    stub_const('ENV', {'defaults-buzz-cola' => 'Totally Awesome!'})
    expect(AppConfig.defaults.buzz.cola).to eq('Totally Awesome!')
  end
end
