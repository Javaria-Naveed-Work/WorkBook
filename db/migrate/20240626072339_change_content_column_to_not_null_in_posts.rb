class ChangeContentColumnToNotNullInPosts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :posts, :content, false
  end
end
