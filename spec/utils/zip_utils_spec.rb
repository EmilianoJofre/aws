RSpec.describe ZipUtils do
  describe 'self.generate_zip' do
    let(:temp_file) { Tempfile.new('documents.zip') }
    let(:url_one) do
      { url: 'google.com', name: 'google', extension: 'png' }
    end
    let(:url_two) do
      { url: 'platan.us', name: 'platanus', extension: 'png' }
    end
    let(:urls_to_download) { [url_one, url_two] }
    let(:zipfile) { double }

    before do
      allow(Zip::OutputStream).to receive(:open).with(temp_file)
      allow(Zip::File).to receive(:open).with(temp_file.path, Zip::File::CREATE).and_yield(zipfile)
      allow(zipfile).to receive(:add)
      described_class.generate_zip(urls_to_download, temp_file)
    end

    after do
      temp_file.close
      temp_file.unlink
    end

    it 'creates ZipOutputStream' do
      expect(Zip::OutputStream).to have_received(:open).with(temp_file)
    end

    it 'creates zip file' do
      expect(Zip::File).to have_received(:open).with(temp_file.path, Zip::File::CREATE)
    end

    it 'adds first file to zip' do
      expect(zipfile).to have_received(:add)
        .with("#{url_one[:name]}.#{url_one[:extension]}", url_one[:url])
    end

    it 'adds second file to zip' do
      expect(zipfile).to have_received(:add)
        .with("#{url_two[:name]}.#{url_two[:extension]}", url_two[:url])
    end
  end
end
