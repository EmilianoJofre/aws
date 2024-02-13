module ActiveUserHelper
  def active_user

    if session["warden.user.user.key"] then
      return User.find(session["warden.user.user.key"][0])
    end

    if session["warden.user.current_v2_supervisor.key"] then
      return Supervisor.find(session["warden.user.current_v2_supervisor.key"].id)
    end

    if session["warden.user.adviser.key"] then
      return Adviser.find(session["warden.user.adviser.key"].id)
    end

    if session["warden.user.relation.key"] then
      return Relation.find(session["warden.user.relation.key"][0])
    end

    return nil
  end

  def type_user
    return 'admin' if session["warden.user.user.key"]
    return 'supervisor' if session["warden.user.current_v2_supervisor.key"]
    return 'adviser' if session["warden.user.adviser.key"]
    return 'investor' if session["warden.user.relation.key"]
    return nil
  end
end
