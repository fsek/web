class Api::GameQuestionSerializer < ActiveModel::Serializer
  attributes(:question, :answer1, :answer2, :answer3)
end
