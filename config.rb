###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration
activate :dato,
  token: 'eba5c67e5115bd8b8d07f1f8d56878509560dfd2b8745128b1',
  base_url: 'http://www.mywebsite.com'


ignore "/product.html"





conn = Faraday.new(url: 'https://app.snipcart.com/api')  do |faraday|
  faraday.basic_auth('ST_MmE3NmQyYmYtZGNkMC00MzRhLThiNTYtYzIyOTVlMzYxZTUyNjM2MTY3MDYzNTM4ODYwODI0', '' )
  faraday.adapter Faraday.default_adapter
end
scps = conn.get do |req|
  req.url "products"
  req.headers['Accept'] = 'application/json'
end
real_products = []
dato.products.each do |p| 
  scp =  JSON.parse(scps.body)["items"].select{|prod| prod["userDefinedId"] == p.id.to_s}.first
  if !scp || scp["stock"].to_i > 0
    real_products << p
  end
end

real_products.each do |p| 
  proxy "/#{p.title.parameterize}.html", "/product.html", locals: { product: p }
end
set :real_products, real_products





# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
