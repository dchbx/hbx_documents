# This script will ready all documents form mongodb StoredFile collection and export them to files on disk
# to run
# padrino r scripts/download_all_documents.rb

files = StoredFile.limit(10)

dir = ARGV[2] || PADRINO_ROOT

dir = File.join(dir, 'doc_store_files')

FileUtils.mkdir_p(dir) unless File.directory?(dir)

files.each do |file|
  raw_bytes = ""
  file.each_chunk do |chunk|
    raw_bytes += chunk
  end

  op_file = File.open(File.join(dir, file.filename), "wb")
  op_file.write raw_bytes
end