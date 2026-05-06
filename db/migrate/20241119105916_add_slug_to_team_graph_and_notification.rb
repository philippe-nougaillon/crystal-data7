class AddSlugToTeamGraphAndNotification < ActiveRecord::Migration[7.2]
  def change
    add_column :teams, :slug, :string
    add_column :graphs, :slug, :string
    add_column :notifications, :slug, :string

    Team.all.each do |team|
      team.update!(slug: SecureRandom.uuid)
    end

    Graph.all.each do |graph|
      graph.update!(slug: SecureRandom.uuid)
    end

    Notification.all.each do |notification|
      notification.update!(slug: SecureRandom.uuid)
    end
  end
end
