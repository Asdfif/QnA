class ApplicationController < ActionController::Base
  def delete_file_from_resource(resource, file_id)
    resource.files.find(file_id).purge
  end
end
