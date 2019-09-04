class AnswerChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answers"
  end
end