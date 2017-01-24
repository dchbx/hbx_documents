HbxDocuments::App.controllers :files do

  register Padrino::Flash

  get :new, :map => "files/new" do
      render 'files/new'
  end

  post :store, :map => "/files" do
    begin
    file = params[:file]
    if file[:tempfile].blank?
      error 422
    end
    t_file = file[:tempfile]
    ct = params[:content_type] || "application/octet-stream"
    f_name = params[:file_name] || params[:file][:filename]
    uri = Aws::S3Storage.save(file, 'tax-documents') || "nice-uri"
    person = Person.where(hbx_id(File.basename(file))).first || (puts "Could not find person for doc #{File.basename(file)}")

    content_type = MIME::Types.type_for(File.basename(file)).first.content_type

    family.documents << Document.new({identifier:uri, title:File.basename(file), format:content_type, subject:subject, rights: 'pii_restricted'})

    family.save!
    sf = StoredFile.store(f_name, ct, t_file)
    status '202'
    sf.id
      redirect('/new', :notice => "Successfully processed file #{params[:file][:filename]} id:#{sf.id}")
    rescue Exception=>e
      redirect('/new', :notice => "Error processing file #{params[:file]}.\n" + e.message)
    end
  end

  get :download, :map => "/files", :with => :id do
    s3 = Aws::S3::Client.new  
    @doc_class = s3.get_object(bucket:'tax-documents', key:'object-key')
    sf = StoredFile.where({"id" => params[:id] }).first
    if sf
      content_type sf.contentType
      response['Content-Disposition'] = "inline;filename=\"#{URI.escape(sf.filename)}\""
      stream do |out|
        sf.each_chunk do |chunk|
          out << chunk
        end
      end
    else
      error 404
    end
  end
end
