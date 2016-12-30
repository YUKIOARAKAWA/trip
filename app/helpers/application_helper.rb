module ApplicationHelper

  # ユーザのプロフィール写真を表示する
  def profile_img(user)
    #if user.image_url?
    #  img_url = user.image_url.url
    #elsif user.provider == 'facebook'
    img_url = "https://graph.facebook.com/#{user.uid}/picture?width=320&height=320"
    #elsif user.provider == 'twitter'
      # img_url = "http://furyu.nazo.cc/twicon/#{user.uid}"
      #　img_url = "https://syamn.cat/api/twicon/id/#{user.uid}"
      #img_url = "http://www.paper-glasses.com/api/twipi/#{user.twiuser}"
    #else
      #gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      #img_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    #end
    # puts img_url
    image_tag(img_url, alt: user.name, class: 'img-responsive js-replace-no-image img-responsive img-circle', width: '100',height: '100', margin: '1px')
  end

  # プランに対して、写真やメンバーを表示する
  def plan_image(plan)
    img_url = "https://graph.facebook.com/#{user.uid}/picture?width=320&height=320"
    image_tag(img_url, alt: user.name, class: 'img-responsive js-replace-no-image img-responsive img-circle', width: '200',height: '200', margin: '1px')
  end

  # ユーザのプロフィール写真を表示する(header用)
  def hedder_profile_img(user)
    img_url = "https://graph.facebook.com/#{user.uid}/picture?width=320&height=320"
    image_tag(img_url, alt: user.name, class: 'img-responsive js-replace-no-image img-responsive img-circle', width: '25',height: '25', margin: '1px')
  end

end
