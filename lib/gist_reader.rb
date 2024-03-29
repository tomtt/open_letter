require 'open-uri'
require 'json'

class GistReader
  class NoValidGistUrlError < StandardError; end

  def self.read_by_id(id)
    gist_api_response = URI.open("https://api.github.com/gists/%s" % id)
    gist_api_data = JSON.parse(gist_api_response.read)
    key_of_first_file = gist_api_data["files"].keys.first
    gist_api_data["files"][key_of_first_file]["content"]
  end

  def self.read(url)
    raise NoValidGistUrlError.new("Url was not present") if !url || url.empty?
    raise NoValidGistUrlError.new("Url was not a gist url") unless url =~ /gist/

    url_components = url.split('/')
    if url_components.include? 'raw'
      URI.open(url).read
    else
      read_by_id(url_components.last)
    end
  end
end
