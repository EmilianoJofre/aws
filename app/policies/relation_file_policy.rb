class RelationFilePolicy < ApplicationPolicy
  def update?
    user_record
  end

  def destroy?
    user_record
  end

  def download?
    user_record || relation_record
  end

  def download_multiple?
    record.each do |r|
      if !(user_record(r) || relation_record(r))
        return false
      end
    end

    true
  end

  private

  def user_record(rec = record)
    rec.relation.user === @user
  end

  def relation_record(rec = record)
    rec.relation === @user
  end
end
