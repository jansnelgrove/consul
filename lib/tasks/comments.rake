namespace :comments do
  desc "Sets cached_votes_up, cached_votes_up, and cached_votes_up for Legislation::Question comments"
  task set_votes_counter: :environment do
    Comment.find_each do |comment|
      comment.set_votes_counter if comment.commentable.is_a? Legislation::Question
    end
  end
end
