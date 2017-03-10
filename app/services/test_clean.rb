class TestClean
  def self.all
    if Rails.env.test?
      Org.destroy_all            if Org.count            > 0
      Team.destroy_all           if Team.count           > 0
      Team::Rank.destroy_all     if Team::Rank.count     > 0
      User.destroy_all           if User.count           > 0
      User::Phone.destroy_all    if User::Phone.count    > 0
      User::Email.destroy_all    if User::Email.count    > 0
      Pgr.destroy_all            if Pgr.count            > 0
      Pgr::Post.destroy_all      if Pgr::Post.count      > 0
      Pgr::Dialog.destroy_all    if Pgr::Dialog.count    > 0
      Pgr::Broadcast.destroy_all if Pgr::Broadcast.count > 0
      Membership.destroy_all     if Membership.count     > 0
      Inbound.destroy_all        if Inbound.count        > 0
    else
      puts "Only works for test database - no records removed."
    end
  end
end
