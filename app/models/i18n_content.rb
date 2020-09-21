class I18nContent < ApplicationRecord
  validates :key, uniqueness: true

  translates :value, touch: true
  globalize_accessors

  # flat_hash returns a flattened hash, a hash with a single level of
  # depth in which each key is composed from the keys of the original
  # hash (whose value is not a hash) by typing in the key of the route
  # from the first level of the original hash
  #
  # Examples:
  #
  # hash = {
  #   'key1' => 'value1',
  #   'key2' => { 'key3' => 'value2',
  #               'key4' => { 'key5' => 'value3' } }
  # }
  #
  # I18nContent.flat_hash(hash) = {
  #   'key1' => 'value1',
  #   'key2.key3' => 'value2',
  #   'key2.key4.key5' => 'value3'
  # }
  #
  # I18nContent.flat_hash(hash, 'string') = {
  #   'string.key1' => 'value1',
  #   'string.key2.key3' => 'value2',
  #   'string.key2.key4.key5' => 'value3'
  # }
  #
  # I18nContent.flat_hash(hash, 'string', { 'key6' => 'value4' }) = {
  #   'key6' => 'value4',
  #   'string.key1' => 'value1',
  #   'string.key2.key3' => 'value2',
  #   'string.key2.key4.key5' => 'value3'
  # }

  def self.flat_hash(input, path = nil, output = {})
    return output.update({ path => input }) unless input.is_a? Hash

    input.map { |key, value| flat_hash(value, [path, key].compact.join("."), output) }
    output
  end

  def self.content_for(tab)
    translations_for(tab).map do |string|
      I18nContent.find_or_initialize_by(key: string)
    end
  end

  def self.translations_for(tab)
    if tab.to_s == "basic"
      basic_translations
    elsif tab.to_s == "custom"
      custom_translations
    else
      flat_hash(translations_hash_for(tab)).keys
    end
  end

  def self.translations_hash_for(tab)
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?

    I18n.backend.send(:translations)[I18n.locale].select do |key, _translations|
      key.to_s == tab.to_s
    end
  end

  def self.basic_translations
    %w[
      debates.index.section_footer.title
      debates.index.section_footer.description
      debates.index.section_footer.help_text_1
      debates.index.section_footer.help_text_2
      debates.new.info
      debates.new.info_link
      debates.new.more_info
      debates.new.recommendation_one
      debates.new.recommendation_two
      debates.new.recommendation_three
      debates.new.recommendation_four
      debates.new.recommendations_title
      proposals.index.section_footer.title
      proposals.index.section_footer.description
      proposals.new.more_info
      proposals.new.recommendation_one
      proposals.new.recommendation_two
      proposals.new.recommendation_three
      proposals.new.recommendations_title
      polls.index.section_footer.title
      polls.index.section_footer.description
      legislation.processes.index.section_footer.title
      legislation.processes.index.section_footer.description
      budgets.index.section_footer.title
      budgets.index.section_footer.description
    ]
  end

  def self.custom_translations
    %w[
      activerecord.attributes.user.postcode
      devise_views.users.registrations.new.postcode_note
      activerecord.attributes.user.country
      devise_views.users.registrations.new.country_note
      legislation.processes.index.section_header.title
      legislation.processes.index.section_header.help
      legislation.questions.comments.comments_title
      legislation.questions.comments.comments_title_help
      legislation.questions.comments.comments_title_link
      legislation.questions.comments.comments_title_url
      legislation.questions.comments.comment_button
      legislation.questions.comments.form.leave_comment_help_text
      legislation.questions.comments.form.leave_comment
      legislation.questions.comments.form.leave_reply
      legislation.questions.comments.form.guidelines
      legislation.questions.comments.form.error
      legislation.questions.comments.form.headline
      legislation.questions.comments.form.headline_placeholder
      admin.users.columns.country
      admin.users.columns.postcode
      legislation.questions.show.title
      legislation.questions.show.first_question
      legislation.questions.show.next_question
      polls.answer_votes
      legislation.questions.comments.original_version
      legislation.questions.comments.proposed_amendment_for
      comments_helper.reply_button
      comments_helper.reply_link
      devise_views.users.registrations.new.help
      devise_views.users.registrations.new.help_link
      devise_views.users.registrations.new.help_url
    ]
  end
end
