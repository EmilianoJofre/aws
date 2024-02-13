class ZipUtils
  def self.generate_zip(urls_to_download, temp_file)
    Zip::OutputStream.open(temp_file)
    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
      urls_to_download.each do |file|
        zipfile.add("#{file[:name]}.#{file[:extension]}", file[:url])
      end
    end
  end
end
