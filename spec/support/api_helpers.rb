module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options = {})
    send method, path, options
  end

  def answer_params
    link1 = FactoryBot.attributes_for(:link)
    link2 = FactoryBot.attributes_for(:link, :gist)
    answer_attributes = FactoryBot.attributes_for(:answer)
    answer_attributes[:links_attributes] = [link1, link2]
    answer_attributes
  end

  def question_params
    link1 = FactoryBot.attributes_for(:link)
    link2 = FactoryBot.attributes_for(:link, :gist)
    question_attributes = FactoryBot.attributes_for(:question)
    question_attributes[:links_attributes] = [link1, link2]
    question_attributes
  end
end
