module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options = {})
    send method, path, options
  end

  #def question_params
  #  link1 = FactoryBot.attributes_for(:link)
  #  link2 = FactoryBot.attributes_for(:link, :gist)
  #  links = [link1, link2]
  #  question_attributes = FactoryBot.attributes_for(:question)
  #  #question_attributes[:links_attributes] = links
  #end
end
