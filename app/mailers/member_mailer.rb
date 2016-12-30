class MemberMailer < ApplicationMailer
  default from: "from@example.com"

  def join_plan_email(user_id,plan_id,current_user)
    @user = User.find(user_id)
    @plan = Plan.find(plan_id)
    mail to: @user.email, subject: "#{current_user.name}さんからプランに招待されました"
  end

  def plan_finish_email(plan,member)
    @plan = plan
    mail to: member.email, subject: "#{@plan.name}のプランが完成しました"
  end

end
