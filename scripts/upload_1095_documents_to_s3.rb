
subject = '1095A' # the business-type of documents being uploaded

dir = ARGV[0] || Rails.root


def hbx_id(file_name)
  file_name.split("_")[3]
end

Dir.glob("#{dir}/**/*").each do |file|
  next if File.directory? file

  uri = Aws::S3Storage.save(file, 'tax-documents') || "nice-uri"
  family = Person.where(hbx_id(File.basename(file))).first || (puts "Could not find person for doc #{File.basename(file)}")

  content_type = MIME::Types.type_for(File.basename(file)).first.content_type

  family.documents << Document.new({identifier:uri, title:File.basename(file), format:content_type, subject:subject, rights: 'pii_restricted'})

  family.save!
end