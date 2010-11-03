kernel = Waw::kernel
db     = AcmScW::database
model  = Waw::ResourceCollection.new('model')
kernel.resources.send(:add_resource, :model, model)
AcmScW::dba_database.schema.logical.each_part{|r|
  model.send(:add_resource, r.name, db[r.name])
}