# config/initializers/pdfkit.rb
PDFKit.configure do |config|
  config.wkhtmltopdf = "#{Rails.root}/bin/wkhtmltopdf-amd64" if Rails.env.production?
  config.default_options = {
    :disable_smart_shrinking => true,
    :page_size => 'Legal',
    :print_media_type => true,
    :encoding => "UTF-8"
  }
  # Use only if your external hostname is unavailable on the server.
  config.root_url = Rails.env.staging? || Rails.env.production? ? "http://app-group-signature.herokuapp.com" : "http://localhost:3000"
  config.verbose = false
end
