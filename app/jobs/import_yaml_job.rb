class ImportYAMLJob
  include SuckerPunch::Job

  def perform(options)
    Importer::YAML.new(options).import
  end
end
