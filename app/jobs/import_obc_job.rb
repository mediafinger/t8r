class ImportOBCJob
  include SuckerPunch::Job

  def perform(options)
    Importer::OBC.new(options).import
  end
end
