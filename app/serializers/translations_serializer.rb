# The resulting json will be a simple array of hashes, (if called with root: false) like:
# [{"key":"BUTTON_ADDCONTACT","t":"Add as contact"},{"key":"BUTTON_DELCONTACT","t":"Delete contact"}, ...]

class TranslationsSerializer < ActiveModel::Serializer
  attributes :key, :t

  def key
    object.phrase.key
  end

  def t
    object.value
  end
end
